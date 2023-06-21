/*
 * Copyright (C) 2020-2022, IrineSistiana
 *
 * This file is part of mosdns.
 *
 * mosdns is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * mosdns is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

package ecs

import (
	"context"

	"github.com/IrineSistiana/mosdns/v5/pkg/dnsutils"
	"github.com/IrineSistiana/mosdns/v5/pkg/query_context"
	"github.com/IrineSistiana/mosdns/v5/plugin/executable/sequence"
	"github.com/miekg/dns"
)

const PluginType = "auto_ecs"

const (
	v4Mask = 24
	v6Mask = 48
)

func init() {
	sequence.MustRegExecQuickSetup(PluginType, QuickSetup)
}

var _ sequence.RecursiveExecutable = (*AutoECS)(nil)

func QuickSetup(_ sequence.BQ, _ string) (any, error) {
	return NewAutoECS(), nil
}

type AutoECS struct{}

func NewAutoECS() *AutoECS {
	return &AutoECS{}
}

func (e *AutoECS) Exec(ctx context.Context, qCtx *query_context.Context, next sequence.ChainWalker) error {
	upgraded, newECS := e.addECS(qCtx)
	err := next.ExecNext(ctx, qCtx)
	if err != nil {
		return err
	}

	if r := qCtx.R(); r != nil {
		if upgraded {
			dnsutils.RemoveEDNS0(r)
		} else {
			if newECS {
				dnsutils.RemoveMsgECS(r)
			}
		}
	}
	return nil
}

func (e *AutoECS) addECS(qCtx *query_context.Context) (upgraded bool, newECS bool) {
	q := qCtx.Q()
	if len(q.Question) != 1 || q.Question[0].Qclass != dns.ClassINET {
		return false, false
	}

	addr, ok := query_context.GetClientAddr(qCtx)
	if !ok || !addr.IsValid() {
		return false, false
	}
	if addr.IsPrivate() {
		return false, false
	}

	var mask uint8
	if addr.Is4() || addr.Is4In6() {
		mask = v4Mask
	} else {
		mask = v6Mask
	}
	ecs := dnsutils.NewEDNS0Subnet(addr.AsSlice(), mask, true)
	opt := q.IsEdns0()

	if opt == nil {
		upgraded = true
		opt = dnsutils.UpgradeEDNS0(q)
	}
	newECS = dnsutils.AddECS(opt, ecs, false)
	return upgraded, newECS
}

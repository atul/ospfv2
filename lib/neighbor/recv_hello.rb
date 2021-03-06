#--
# Copyright 2010 Jean-Michel Esnault.
# All rights reserved.
# See LICENSE.txt for permissions.
#
#
# This file is part of OSPFv2.
# 
# OSPFv2 is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# OSPFv2 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with OSPFv2.  If not, see <http://www.gnu.org/licenses/>.
#++

module OSPFv2
  class Neighbor
    
    def recv_hello(hello, from, port)
      @neighbor_ip = from
      @state.recv_hello self, hello, from
    rescue Exception => e
      debug "rescued #{e.inspect}"
    end

    def recv_link_state_update(ls_update, from, port)
      ls_ack = LinkStateAck.ack_ls_update ls_update, :area_id=> @area_id, :router_id=> @router_id
      send ls_ack, OSPFv2::AllDRouters #from
      unless @ls_req_list.empty?
        ls_update.each { |l| 
          if @ls_req_list.has_key?(l.key)
            debug "*** deleting #{l.key.inspect} from Ls Req List! ***"
            @ls_req_list.delete(l.key) 
          end
        }
        new_state Full.new, 'loading_done' if @ls_req_list.empty?
       end
      @ls_db.recv_link_state_update ls_update
    end
  end 
end
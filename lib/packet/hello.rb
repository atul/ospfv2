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

# 
# A.3.2 The Hello packet
# 
# Hello packets are OSPF packet type 1.  These packets are sent
# periodically on all interfaces (including virtual links) in order to
# establish and maintain neighbor relationships.  In addition, Hello
# Packets are multicast on those physical networks having a multicast
# or broadcast capability, enabling dynamic discovery of neighboring
# routers.
# 
# All routers connected to a common network must agree on certain
# parameters (Network mask, HelloInterval and RouterDeadInterval).
# These parameters are included in Hello packets, so that differences
# can inhibit the forming of neighbor relationships.  A detailed
# explanation of the receive processing for Hello packets is presented
# in Section 10.5.  The sending of Hello packets is covered in Section
# 9.5.
# 
#     0                   1                   2                   3
#     0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
#    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#    |   Version #   |       1       |         Packet length         |
#    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#    |                          Router ID                            |
#    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#    |                           Area ID                             |
#    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#    |           Checksum            |             AuType            |
#    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#    |                       Authentication                          |
#    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#    |                       Authentication                          |
#    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#    |                        Network Mask                           |
#    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#    |         HelloInterval         |    Options    |    Rtr Pri    |
#    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#    |                     RouterDeadInterval                        |
#    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#    |                      Designated Router                        |
#    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#    |                   Backup Designated Router                    |
#    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#    |                          Neighbor                             |
#    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#    |                              ...                              |
# 
# 
# Network mask
#     The network mask associated with this interface.  For example,
#     if the interface is to a class B network whose third byte is
#     used for subnetting, the network mask is 0xffffff00.
# 
# Options
#     The optional capabilities supported by the router, as documented
#     in Section A.2.
# 
# HelloInterval
#     The number of seconds between this router's Hello packets.
# 
# Rtr Pri
#     This router's Router Priority.  Used in (Backup) Designated
#     Router election.  If set to 0, the router will be ineligible to
#     become (Backup) Designated Router.
# 
# RouterDeadInterval
#     The number of seconds before declaring a silent router down.
# 
# Designated Router
#     The identity of the Designated Router for this network, in the
#     view of the sending router.  The Designated Router is identified
#     here by its IP interface address on the network.  Set to 0.0.0.0
#     if there is no Designated Router.
# 
# Backup Designated Router
#     The identity of the Backup Designated Router for this network,
#     in the view of the sending router.  The Backup Designated Router
#     is identified here by its IP interface address on the network.
#     Set to 0.0.0.0 if there is no Backup Designated Router.
# 
# Neighbor
#     The Router IDs of each router from whom valid Hello packets have
#     been seen recently on the network.  Recently means in the last
#     RouterDeadInterval seconds.
#     
#     
# A.2 The Options field
# 
#    The 24-bit OSPF Options field is present in OSPF Hello packets,
#    Database Description packets and certain LSAs (router-LSAs, network-
#    LSAs, inter-area-router-LSAs and link-LSAs). The Options field
#    enables OSPF routers to support (or not support) optional
#    capabilities, and to communicate their capability level to other OSPF
#    routers.  Through this mechanism routers of differing capabilities
#    can be mixed within an OSPF routing domain.
# 
#    An option mismatch between routers can cause a variety of behaviors,
#    depending on the particular option. Some option mismatches prevent
#    neighbor relationships from forming (e.g., the E-bit below); these
#    mismatches are discovered through the sending and receiving of Hello
#    packets. Some option mismatches prevent particular LSA types from
#    being flooded across adjacencies (e.g., the MC-bit below); these are
#    discovered through the sending and receiving of Database Description
#    packets. Some option mismatches prevent routers from being included
#    in one or more of the various routing calculations because of their
#    reduced functionality (again the MC-bit is an example); these
#    mismatches are discovered by examining LSAs.
# 
#    Six bits of the OSPF Options field have been assigned. Each bit is
#    described briefly below. Routers should reset (i.e.  clear)
#    unrecognized bits in the Options field when sending Hello packets or
#    Database Description packets and when originating LSAs. Conversely,
#    routers encountering unrecognized Option bits in received Hello
#    Packets, Database Description packets or LSAs should ignore the
#    capability and process the packet/LSA normally.
# 
# 
#                              1                     2
#          0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8  9  0  1  2  3
#         -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--+--+--+--+--+--+
#          | | | | | | | | | | | | | | | | | |DC| R| N|MC| E|V6|
#         -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--+--+--+--+--+--+
# 
#                         The Options field
# 
#    V6-bit
#      If this bit is clear, the router/link should be excluded from IPv6
#      routing calculations. See Section 3.8 of this memo.
# 
#    E-bit
#      This bit describes the way AS-external-LSAs are flooded, as
#      described in Sections 3.6, 9.5, 10.8 and 12.1.2 of [Ref1].
# 
#    MC-bit
#      This bit describes whether IP multicast datagrams are forwarded
#      according to the specifications in [Ref7].
# 
#    N-bit
#      This bit describes the handling of Type-7 LSAs, as specified in
#      [Ref8].
# 
#    R-bit
#      This bit (the `Router' bit) indicates whether the originator is an
#      active router.  If the router bit is clear routes which transit the
#      advertising node cannot be computed. Clearing the router bit would
#      be appropriate for a multi-homed host that wants to participate in
#      routing, but does not want to forward non-locally addressed
#      packets.
# 
#    DC-bit
#      This bit describes the router's handling of demand circuits, as
#      specified in [Ref10].
# 
# 

require 'packet/ospf_packet'
require 'ie/options'
require 'set'

module OSPFv2
  
  class Hello < OspfPacket
    
    DesignatedRouterId        = Class.new(Id)
    BackupDesignatedRouterId  = Class.new(Id)
    Netmask                   = Class.new(Id)
    
    attr_reader :netmask, :designated_router_id, :backup_designated_router_id
    attr_reader :hello_interval, :options, :rtr_pri, :router_dead_interval, :neighbors
    attr_writer_delegate :designated_router_id, :backup_designated_router_id
    
    class Neighbors
      Neighbor = Class.new(OSPFv2::Id)
      attr_reader :routers
      def initialize(arg=nil)
        @set = Set.new
        [arg].compact.flatten.each { |x| self + x }
      end
      def +(id)
        @set << neighbor(id)
      end
      def neighbors
        @set.collect.sort
      end
      alias :ids :neighbors
      def has?(id)
        ids.include?(neighbor(id))
      end
      def -(id)
        @set.delete neighbor(id)
      end
      def encode 
        ids.pack('N*')
      end
      def [](val)
        neighbors[val]
      end
      def to_s_ary
        ids.collect { |id| Neighbor.new(id).to_ip  }
      end
      private
      def neighbor(id)
        Neighbor.new(id).to_i
      end
      
    end

    
    def initialize(_arg={})
      arg = _arg.dup
      if arg.is_a?(Hash)
        arg.merge!({:packet_type=>1})
        super arg
        @designated_router_id = DesignatedRouterId.new
        @backup_designated_router_id = BackupDesignatedRouterId.new
        @options = Options.new
        @rtr_pri = 0
        @netmask = Netmask.new
        @neighbors = nil
        @hello_interval, @router_dead_interval = 10, 40
        set arg
      elsif arg.is_a?(String)
        parse arg
      elsif arg.is_a?(Hello)
        parse arg.encode
      else
        raise ArgumentError, "Invalid argument", caller
      end
    end
    
    def neighbors=(val)
      @neighbors ||=Hello::Neighbors.new
      self.neighbors + val
    end
    
    def remove_neighbor(val)
      self.neighbors - val
    end
    def has_neighbor?(neighbor)
      @neighbors ||=Hello::Neighbors.new
      neighbors.has?(neighbor)
    end
        
    def add_router_id(hello)
      self.neighbors = hello.router_id.to_hash
    end

    def to_s_verbose
      super +
      [@netmask, @options, rtr_pri_to_s, @designated_router_id, @backup_designated_router_id, neighbors_to_s].collect { |x| x.to_s }.join("\n ")
    end

    def to_s
      s = []
      s << super
      s << "HellInt #{hello_interval}, DeadInt #{router_dead_interval}, Options #{options.to_s}, mask #{netmask}"
      s << "Prio #{@rtr_pri}, DR #{designated_router_id.to_ip}, BDR #{backup_designated_router_id.to_ip}"
      s << "Neighbors: #{@neighbors.to_s_ary.join(',')}" if @neighbors
      s.join("\n ")
    end
    
    def encode
      packet =[]
      packet << netmask.encode
      packet << [@hello_interval, @options.to_i, @rtr_pri, @router_dead_interval].pack('nCCN')
      packet << @designated_router_id.encode
      packet << @backup_designated_router_id.encode
      packet << neighbors.encode if neighbors
      super packet.join
    rescue Exception => e
      p e
    end
    
    private
    
    def neighbors_to_s
      ["Neighbors:", neighbors.collect { |x| x.to_s(nil) } ].join("\n  ")
    end
    def router_dead_interval_s
      ["Neighbors:", neighbors.collect { |x| x.to_s(nil) } ].join("\n  ")
    end
    
    def parse(_s)
      s = super(_s)
      hello, _ = s.unpack("a#{@_packet_len-24}a*")
      netmask, @hello_interval, options, @rtr_pri, @router_dead_interval, dr, bdr = hello.slice!(0,20).unpack('NnCCNNN')
      @netmask = Netmask.new netmask
      @options = Options.new options
      @designated_router_id = DesignatedRouterId.new dr
      @backup_designated_router_id = BackupDesignatedRouterId.new bdr
      @neighbors ||=Hello::Neighbors.new      
      while hello.size>0
        self.neighbors= hello.slice!(0,4).unpack('N')[0]
      end
    end
    
  end

end

load "../../../test/ospfv2/packet/#{ File.basename($0.gsub(/.rb/,'_test.rb'))}" if __FILE__ == $0


__END__

0201002c
01010101
00000000
8be60000
00000000
00000000

ffffff00
000a1201
00000028
c0a89e0d
00000000


fff600030001000400000001

>> ["0201002c01010101000000008be600000000000000000000ffffff00000a120100000028c0a89e0d00000000fff600030001000400000001"]
["ffffff00000a120100000028c0a89e0d00000000fff600030001000400000001"]
44
["0001000400000001"]
[""]


   Source: 192.168.158.13 (192.168.158.13)
    Destination: 224.0.0.5 (224.0.0.5)
Open Shortest Path First
    OSPF Header
        OSPF Version: 2
        Message Type: Hello Packet (1)
        Packet Length: 44
        Source OSPF Router: 1.1.1.1 (1.1.1.1)
        Area ID: 0.0.0.0 (Backbone)
        Packet Checksum: 0x8be6 [correct]
        Auth Type: Null
        Auth Data (none)
    OSPF Hello Packet
        Network Mask: 255.255.255.0
        Hello Interval: 10 seconds
        Options: 0x12 (L, E)
            0... .... = DN: DN-bit is NOT set
            .0.. .... = O: O-bit is NOT set
            ..0. .... = DC: Demand circuits are NOT supported
            ...1 .... = L: The packet contains LLS data block
            .... 0... = NP: Nssa is NOT supported
            .... .0.. = MC: NOT multicast capable
            .... ..1. = E: ExternalRoutingCapability
        Router Priority: 1
        Router Dead Interval: 40 seconds
        Designated Router: 192.168.158.13
        Backup Designated Router: 0.0.0.0
    OSPF LLS Data Block
        Checksum: 0xfff6
        LLS Data Length: 12 bytes
        Extended options TLV
            Type: 1
            Length: 4
            Options: 0x00000001 (LR)
                .... .... .... .... .... .... .... ..0. = RS: Restart Signal (RS-bit) is NOT set
                .... .... .... .... .... .... .... ...1 = LR: LSDB Resynchronization (LR-bit) is SET


0000  01 00 5e 00 00 05 cc 00 09 41 00 10 08 00 45 c0   ..^......A....E.
0010  00 4c 1b 86 00 00 01 59 5e 58 c0 a8 9e 0d e0 00   .L.....Y^X......
0020  00 05 02 01 00 2c 01 01 01 01 00 00 00 00 8b e6   .....,..........
0030  00 00 00 00 00 00 00 00 00 00 ff ff ff 00 00 0a   ................
0040  12 01 00 00 00 28 c0 a8 9e 0d 00 00 00 00 ff f6   .....(..........
0050  00 03 00 01 00 04 00 00 00 01                     ..........


2c


      02 01 00 2c 01 01 01 01 00 00 00 00 8b e6    14
00 00 00 00 00 00 00 00 00 00 ff ff ff 00 00 0a    16 30
12 01 00 00 00 28 c0 a8 9e 0d 00 00 00 00 ff f6    16 46
00 03 00 01 00 04 00 00 00 01                      10 56







import Foundation

// Import libzt
import zt

// Helper function to display details about local ZeroTier Node (on event)
let printNodeDetails : @convention(c) (UnsafeMutableRawPointer?) -> Void =
{
    (msgPtr) -> Void in
    let msg = msgPtr?.bindMemory(to: zts_event_msg_t.self, capacity: 1)
    let d = msg?.pointee.node;
    print(String(format: "\t- node_id        : %llx", d!.pointee.node_id));
    print(String(format: "\t- version        : %d.%d.%d", d!.pointee.ver_major, d!.pointee.ver_minor, d!.pointee.ver_rev));
    print(String(format: "\t- port_primary   : %d", d!.pointee.port_primary));
    print(String(format: "\t- port_secondary : %d", d!.pointee.port_secondary));
}

// Helper function to display details about local ZeroTier network (on event)
let printNetworkDetails : @convention(c) (UnsafeMutableRawPointer?) -> Void =
{
    (msgPtr) -> Void in
    let msg = msgPtr?.bindMemory(to: zts_event_msg_t.self, capacity: 1)
    let d = msg?.pointee.network;
    let name = ""; // String(d!.pointee.name);
    
    print(String(format: "\t- net_id              : %llx", d!.pointee.net_id));
    print(String(format: "\t- mac                 : %lx", d!.pointee.mac));
    print(String(format: "\t- name                : %s", name));
    print(String(format: "\t- type                : %d", Int(d!.pointee.type.rawValue)));
    /* MTU for the virtual network can be set via our web API */
    print(String(format: "\t- mtu                 : %d", d!.pointee.mtu));
    print(String(format: "\t- dhcp                : %d", d!.pointee.dhcp));
    print(String(format: "\t- bridge              : %d", d!.pointee.bridge));
    print(String(format: "\t- broadcast_enabled   : %d", d!.pointee.broadcast_enabled));
    print(String(format: "\t- port_error          : %d", d!.pointee.port_error));
    print(String(format: "\t- netconf_rev         : %d", d!.pointee.netconf_rev));
    print(String(format: "\t- route_count         : %d", d!.pointee.route_count));
    print(String(format: "\t- multicast_sub_count : %d", d!.pointee.multicast_sub_count));
    
    /*
     var addresses: [zts_sockaddr_storage] = convertTupleToArray(from: d!.pointee.assignedAddresses)
     
     print("\t- addresses:\n");
     for i in 0...d!.pointee.assignedAddressCount {
     if (addresses[Int(i)].ss_family == ZTS_AF_INET) {
     // Allocate a byte array that can hold the largest possible IPv4 human-readable string
     var ipCharByteArray = Array<Int8>(repeating: 0, count: Int(ZTS_INET_ADDRSTRLEN))
     // Cast unsafe pointer from zts_sockaddr_storage to zts_sockaddr_in
     var addr:zts_sockaddr_in = withUnsafePointer(to: &(addresses[Int(i)])) {
     $0.withMemoryRebound(to: zts_sockaddr_in.self, capacity: 1) {
     $0.pointee
     }
     }
     // Pass unsafe pointer (addr) to a ntop to convert into human-readable byte array
     zts_inet_ntop(ZTS_AF_INET, &(addr.sin_addr), &ipCharByteArray, UInt32(ZTS_INET_ADDRSTRLEN))
     //print(ipCharByteArray) // [49, 55, 50, 46, 50, 55, 46, 49, 49, 54, 46, 49, 54, 55, 0, 0]
     // Somehow convery Int8 byte array to Swift String ???
     //let ipString = String(bytes: ipStr, encoding: .utf8)
     //print(ipString)
     
     // Pass unsafe pointer (addr) to a ntop to convert into human-readable byte array
     // convert to UInt8 byte array
     let uintArray = ipCharByteArray.map { UInt8(bitPattern: $0) }
     if let string = String(bytes: uintArray, encoding: .utf8) {
     print("\t\t-", string)
     }
     }
     if (addresses[Int(i)].ss_family == ZTS_AF_INET6) {
     // ...
     }
     }
     */
}

// Helper function to display details about remote ZeroTier peer node (on event)
let printPeerDetails : @convention(c) (UnsafeMutableRawPointer?) -> Void =
{
    (msgPtr) -> Void in
    let msg = msgPtr?.bindMemory(to: zts_event_msg_t.self, capacity: 1)
    let d = msg?.pointee.peer;
    print(String(format: "\t- peer_id      : %llx", d!.pointee.peer_id));
    print(String(format: "\t- role         : %d", Int(d!.pointee.role.rawValue)));
    print(String(format: "\t- latency      : %llx", d!.pointee.latency));
    print(String(format: "\t- path_count   : %llx", d!.pointee.path_count));
    print(String(format: "\t- version      : %d.%d.%d", d!.pointee.ver_major, d!.pointee.ver_minor, d!.pointee.ver_rev));
    print(String(format: "\t- paths:\n"));
    
    /*
     for i in 0...d!.pointee.pathCount {
     // ...
     }
     */
}

// Helper function to display details about local ZeroTier netif (on event) -- Can be ignored
let printNetifDetails : @convention(c) (UnsafeMutableRawPointer?) -> Void =
{
    (msgPtr) -> Void in
    let msg = msgPtr?.bindMemory(to: zts_event_msg_t.self, capacity: 1)
    let d = msg?.pointee.netif;
    print(String(format: "\t- net_id : %llx", d!.pointee.net_id));
    print(String(format: "\t- mac    : %llx", d!.pointee.mac));
    print(String(format: "\t- mtu    : %d", d!.pointee.mtu));
}

// Handle ZeroTier events (e.g. successful node start, join, leave, etc) --- Can be ignored
let onZeroTierEvent : @convention(c) (UnsafeMutableRawPointer?) -> Void =
{
    (msgPtr) -> Void in
    let msg = msgPtr?.bindMemory(to: zts_event_msg_t.self, capacity: 1)
    let eventCode = zts_event_t(rawValue: UInt32(msg!.pointee.event_code));
    let network = msg?.pointee.network;
    let peer = msg?.pointee.peer;
    
    print("code:", eventCode);
    
    
    
    // Node events
    
    if (eventCode == ZTS_EVENT_NODE_UP)
    {
        print("ZTS_EVENT_NODE_UP\n")
        //printNodeDetails(msg)
    }
    
    if (eventCode == ZTS_EVENT_NODE_ONLINE)
    {
        print("ZTS_EVENT_NODE_ONLINE\n")
    }
    
    if (eventCode == ZTS_EVENT_NODE_OFFLINE)
    {
        print("ZTS_EVENT_NODE_OFFLINE\n")
    }
    
    if (eventCode == ZTS_EVENT_NODE_DOWN)
    {
        print("ZTS_EVENT_NODE_DOWN\n")
    }
    
    if (eventCode == ZTS_EVENT_NODE_FATAL_ERROR)
    {
        print("ZTS_EVENT_NODE_FATAL_ERROR\n")
    }
    
    
    
    // Network events
    
    if (eventCode == ZTS_EVENT_NETWORK_NOT_FOUND)
    {
        let networkId:UInt64 = network!.pointee.net_id
        print(String(format: "ZTS_EVENT_NETWORK_NOT_FOUND (%llx)", networkId))
    }
    
    if (eventCode == ZTS_EVENT_NETWORK_REQ_CONFIG)
    {
        let networkId:UInt64 = network!.pointee.net_id
        print(String(format: "ZTS_EVENT_NETWORK_REQ_CONFIG (%llx)", networkId))
    }
    
    if (eventCode == ZTS_EVENT_NETWORK_ACCESS_DENIED)
    {
        let networkId:UInt64 = network!.pointee.net_id
        print(String(format: "ZTS_EVENT_NETWORK_ACCESS_DENIED (%llx)", networkId))
    }
    
    if (eventCode == ZTS_EVENT_NETWORK_READY_IP4)
    {
        let networkId:UInt64 = network!.pointee.net_id
        print(String(format: "ZTS_EVENT_NETWORK_READY_IP4 (%llx)", networkId))
    }
    
    if (eventCode == ZTS_EVENT_NETWORK_READY_IP6)
    {
        let networkId:UInt64 = network!.pointee.net_id
        print(String(format: "ZTS_EVENT_NETWORK_READY_IP6 (%llx)", networkId))
    }
    
    if (eventCode == ZTS_EVENT_NETWORK_DOWN)
    {
        let networkId:UInt64 = network!.pointee.net_id
        print(String(format: "ZTS_EVENT_NETWORK_DOWN (%llx)", networkId))
    }
    
    if (eventCode == ZTS_EVENT_NETWORK_UPDATE)
    {
        print("ZTS_EVENT_NETWORK_UPDATE\n")
        //printNetworkDetails(msg)
    }
    
    
    
    // Address assignment events
    
    if (eventCode ==  ZTS_EVENT_ADDR_ADDED_IP4)
    {
        print("ZTS_EVENT_ADDR_ADDED_IP4\n")
    }
    
    if (eventCode ==  ZTS_EVENT_ADDR_ADDED_IP6)
    {
        print("ZTS_EVENT_ADDR_ADDED_IP6\n")
    }
    
    if (eventCode ==  ZTS_EVENT_ADDR_REMOVED_IP4)
    {
        print("ZTS_EVENT_ADDR_REMOVED_IP4\n")
    }
    
    if (eventCode ==  ZTS_EVENT_ADDR_REMOVED_IP6)
    {
        print("ZTS_EVENT_ADDR_REMOVED_IP6\n")
    }
    
    
    
    
    // Remote peer events
    
    if (eventCode ==  ZTS_EVENT_PEER_DIRECT)
    {
        let peerId:UInt64 = peer!.pointee.peer_id
        print(String(format: "ZTS_EVENT_PEER_DIRECT (%llx)", peerId))
        //printPeerDetails(msg)
    }
    
    if (eventCode ==  ZTS_EVENT_PEER_RELAY)
    {
        let peerId:UInt64 = peer!.pointee.peer_id
        print(String(format: "ZTS_EVENT_PEER_RELAY (%llx)", peerId))
        //printPeerDetails(msg)
    }
    
    if (eventCode ==  ZTS_EVENT_PEER_PATH_DISCOVERED)
    {
        let peerId:UInt64 = peer!.pointee.peer_id
        print(String(format: "ZTS_EVENT_PEER_PATH_DISCOVERED (%llx)", peerId))
        //printPeerDetails(msg)
    }
    
    if (eventCode ==  ZTS_EVENT_PEER_PATH_DEAD)
    {
        let peerId:UInt64 = peer!.pointee.peer_id
        print(String(format: "ZTS_EVENT_PEER_PATH_DEAD (%llx)", peerId))
        //printPeerDetails(msg)
    }
    
    
    
    
    // Network stack events
    
    if (eventCode ==  ZTS_EVENT_NETIF_UP) {
        print("ZTS_EVENT_NETIF_UP\n")
    }
    
    if (eventCode ==  ZTS_EVENT_NETIF_DOWN) {
        print("ZTS_EVENT_NETIF_DOWN\n")
    }
    
    if (eventCode ==  ZTS_EVENT_NETIF_REMOVED) {
        print("ZTS_EVENT_NETIF_REMOVED\n")
    }
    
    if (eventCode ==  ZTS_EVENT_NETIF_LINK_UP) {
        print("ZTS_EVENT_NETIF_LINK_UP\n")
    }
    
    if (eventCode ==  ZTS_EVENT_NETIF_LINK_DOWN) {
        print("ZTS_EVENT_NETIF_LINK_DOWN\n")
    }
    
    if (eventCode ==  ZTS_EVENT_STACK_UP) {
        print("ZTS_EVENT_STACK_UP\n")
    }
    
    if (eventCode ==  ZTS_EVENT_STACK_DOWN) {
        print("ZTS_EVENT_STACK_DOWN\n")
    }
}


// Example user application logic
func main()
{
    // Configure local ZeroTier node
    
    zts_init_set_event_handler(onZeroTierEvent);
    zts_init_set_port(9993);

    // Start local ZeroTier node
    
    zts_node_start();
    
    // Wait for local ZeroTier node to come online
    
    while(zts_node_is_online() != 1) {
        print("waiting for node",  String(format:"%llX", zts_node_get_id()), "to come online ...");
        zts_util_delay(1000);
    }
    
    // Join ZeroTier network
    
    let nwid : UInt64 = 0xcb948a8fbd5a28b1; // Specify your network ID here
    print("Joining network", String(format:"%llX", nwid));
    zts_net_join(nwid);
    
    // Example using raw BSD sockets
    
    // example_raw_sockets();
    
    // Idle so that app doesn't exit
    
    print("Idling...");
    while(true) {
        sleep(1);
    }
}

func example_raw_sockets()
{
    // Create address structure
    let addr_str = "0.0.0.0"
    let port = 8080
    var in4 = zts_sockaddr_in(sin_len: UInt8(MemoryLayout<zts_sockaddr_in>.size),
                              sin_family: UInt8(ZTS_AF_INET),
                              sin_port: UInt16(port).bigEndian,
                              sin_addr: zts_in_addr(s_addr: 0),
                              sin_zero: (0,0,0,0,0,0,0,0))
    zts_inet_pton(ZTS_AF_INET, addr_str, &(in4.sin_addr));
    
    print("fd=", zts_socket(ZTS_AF_INET, ZTS_SOCK_STREAM, 0));
}

main()

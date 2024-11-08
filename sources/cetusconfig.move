module testconfig::testconfig {
    struct AdminCap has store, key {
        id: sui::object::UID,
    }
    
    struct ProtocolFeeClaimCap has store, key {
        id: sui::object::UID,
    }
    
    struct FeeTier has copy, drop, store {
        tick_spacing: u32,
        fee_rate: u64,
    }
    
    struct GlobalConfig has store, key {
        id: sui::object::UID,
        protocol_fee_rate: u64,
        fee_tiers: sui::vec_map::VecMap<u32, FeeTier>,
        package_version: u64,
    }
    
    struct SetPackageVersion has copy, drop {
        new_version: u64,
        old_version: u64,
    }
    
    public fun fee_rate(arg0: &FeeTier) : u64 {
        arg0.fee_rate
    }
    
    public fun fee_tiers(arg0: &GlobalConfig) : &sui::vec_map::VecMap<u32, FeeTier> {
        &arg0.fee_tiers
    }
    
    public fun get_fee_rate(arg0: u32, arg1: &GlobalConfig) : u64 {
        assert!(sui::vec_map::contains<u32, FeeTier>(&arg1.fee_tiers, &arg0), 2);
        sui::vec_map::get<u32, FeeTier>(&arg1.fee_tiers, &arg0).fee_rate
    }
    
    public fun get_protocol_fee_rate(arg0: &GlobalConfig) : u64 {
        arg0.protocol_fee_rate
    }
    
    fun init(arg0: &mut sui::tx_context::TxContext) {
        let v0 = GlobalConfig{
            id                : sui::object::new(arg0), 
            protocol_fee_rate : 2000, 
            fee_tiers         : sui::vec_map::empty<u32, FeeTier>(), 
            // acl               : 0x1eabed72c53feb3805120a081dc15963c204dc8d091542592abaf7a35689b2fb::acl::new(arg0), 
            package_version   : 1,
        };
        let v1 = AdminCap{id: sui::object::new(arg0)};
        let v2 = v0;
        let v3 = sui::tx_context::sender(arg0);
        // set_roles(&v1, &mut v2, v3, 0 | 1 << 0 | 1 << 1 | 1 << 4 | 1 << 3);
        sui::transfer::transfer<AdminCap>(v1, v3);
        sui::transfer::share_object<GlobalConfig>(v2);
    }
    
    public fun max_fee_rate() : u64 {
        200000
    }
    
    public fun max_protocol_fee_rate() : u64 {
        3000
    }
    
    public fun protocol_fee_rate(arg0: &GlobalConfig) : u64 {
        arg0.protocol_fee_rate
    }
    
    public fun tick_spacing(arg0: &FeeTier) : u32 {
        arg0.tick_spacing
    }
    
    public fun update_package_version(_: &AdminCap, arg1: &mut GlobalConfig, arg2: u64) {
        arg1.package_version = arg2;
        let v0 = SetPackageVersion{
            new_version : arg2, 
            old_version : arg1.package_version,
        };
        sui::event::emit<SetPackageVersion>(v0);
    }
}


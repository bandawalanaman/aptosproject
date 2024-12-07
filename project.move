module MyModule::DecentralizedFileStorage {
    use aptos_framework::signer;
    use aptos_framework::vector;

    /// Struct representing a file in the decentralized storage.
    struct File has store, key {
        owner: address,        // Owner of the file
        cid: vector<u8>,       // Content identifier for IPFS
        permissions: vector<address>, // List of addresses with access permissions
    }

    /// Function to upload a file to the decentralized storage.
    public fun upload_file(owner: &signer, cid: vector<u8>, permissions: vector<address>) {
        let file = File {
            owner: signer::address_of(owner),
            cid,
            permissions,
        };
        move_to(owner, file);
    }

    /// Function to grant access to a user for a specific file.
    public fun grant_access(owner: &signer, file_owner: address, user: address) acquires File {
        let file = borrow_global_mut<File>(file_owner);
        assert!(file.owner == signer::address_of(owner), 1); // Ensure the caller is the owner

        vector::push_back(&mut file.permissions, user);
    }
}

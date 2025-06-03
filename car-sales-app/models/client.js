class Client {
    constructor(id, full_name, phone, email, address) {
        this.id = id;
        this.full_name = full_name;
        this.phone = phone;
        this.email = email;
        this.address = address;
    }

    static fromJson(json) {
        return new Client(
            json.id_client,
            json.full_name,
            json.phone,
            json.email,
            json.address
        );
    }

    toJson() {
        return {
            full_name: this.full_name,
            phone: this.phone,
            email: this.email,
            address: this.address
        };
    }
}

module.exports = Client;
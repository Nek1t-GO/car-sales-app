

class Car {
    constructor(id, year, idModel, color, vin, price) {
        this.id = id;
        this.year = year;
        this.idModel = idModel;
        this.color = color;
        this.vin = vin;
        this.price = price;
    }

    static fromJson(json) {
        return new Car(
            json.id_car,
            json.year,
            json.id_model,
            json.color,
            json.vin,
            json.price
        );
    }

    toJson() {
        return {
            year: this.year,
            id_model: this.idModel,
            color: this.color,
            vin: this.vin,
            price: this.price
        };
    }
}

module.exports = Car;
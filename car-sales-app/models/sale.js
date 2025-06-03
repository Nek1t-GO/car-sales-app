

class Sale {
    constructor(id, idClient, idCar, idEmployee, saleDate, finalPrice) {
        this.id = id;
        this.idClient = idClient;
        this.idCar = idCar;
        this.idEmployee = idEmployee;
        this.saleDate = new Date(saleDate);
        this.finalPrice = finalPrice;

        // Для отображения
        this.clientName = '';
        this.carName = '';
        this.employeeName = '';
    }

    setClientName(name) {
        this.clientName = name;
    }

    setCarName(name) {
        this.carName = name;
    }

    setEmployeeName(name) {
        this.employeeName = name;
    }

    static fromJson(json) {
        return new Sale(
            json.id_sale,
            json.id_client,
            json.id_car,
            json.id_employee,
            json.sale_date,
            json.final_price
        );
    }

    toJson() {
        const json = {
            id_sale: this.id,
            id_client: this.idClient,
            id_car: this.idCar,
            id_employee: this.idEmployee,
            sale_date: this.saleDate.toISOString().split('T')[0],
            final_price: this.finalPrice
        };
        console.log('📝 Обновляем продажу: ', json);
        return json;
    }
}

module.exports = Sale;
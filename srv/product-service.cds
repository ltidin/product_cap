using {db} from '../db/schema';

service ProductService {
    entity Products     as projection on db.Products;
    entity ProductGroup as projection on db.ProductGroups;
    entity Phase        as projection on db.Phases;
    entity UOM          as projection on db.UOM;
    entity Markets      as projection on db.Markets;
    entity Countries    as projection on db.Countries;
    entity Orders       as projection on db.Orders;
}

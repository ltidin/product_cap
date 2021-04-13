using { db } from '../db/schema';

service ProductService {
   entity Products as projection on db.Products;
   entity ProductGroup as projection on db.ProductGroup;
   entity Phase as projection on db.Phase;
}
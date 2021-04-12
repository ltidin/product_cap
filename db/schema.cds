namespace db;

using {
    cuid,
    managed,
    Currency
} from '@sap/cds/common';
using {SapStandartEntity} from './common';


entity Product : SapStandartEntity, cuid, managed {
    prod_id       : String(16);
    prodGroup     : Association to one ProductGroup;
    height        : Integer;
    depth         : Integer;
    width         : Integer;
    price         : Decimal;
    priceCurrency : Currency;
    taxrate       : Decimal;
}

entity ProductGroup : SapStandartEntity {
    key ID       : String(3);
        pgname   : String(50);
        imageURL : String;
}

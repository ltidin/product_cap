namespace db;

using {
    cuid,
    managed,
    Currency,
    Country
} from '@sap/cds/common';

using {lib} from './lib/common';

annotate cuid with {
    ID @(
        odata.Type  : 'Edm.String',
        title       : '{i18n>guid}',
        description : '{i18n>guidDescription}'
    );
};


entity Products : cuid, managed {
    prodId          : String(16);
    description     : localized String;
    pgId            : ProductGroups : ID;
    toProdGroup     : Association to one ProductGroups
                          on toProdGroup.ID = pgId;
    toMarkets       : Association to many Markets
                          on toMarkets.toProduct = $self;
    toOrders        : Association to many Ord2Prod
                          on toOrders.productID = ID;
    sizeUom         : UOM : msehi;
    toUom           : Association to one UOM
                          on toUom.msehi = sizeUom;
    height          : Integer;
    depth           : Integer;
    width           : Integer;
    price           : Decimal;
    toPriceCurrency : Currency;
    taxrate         : Decimal;
}

entity ProductGroups {
    key ID         : Integer;
        name       : localized String(50);
        imageURL   : String;
        toProducts : Association to many Products
                         on toProducts.toProdGroup = $self;
}

entity Phases {
    key ID          : String(5);
        name        : localized String(50);
        description : localized String;
        toOrders    : Association to many Orders
                          on toOrders.toPhase = $self;
}


entity UOM {
    key msehi      : String(3);
        dimid      : String(6);
        isocode    : String(3);
        toProducts : Association to many Products
                         on toProducts.toUom = $self;
}

entity Markets : cuid, managed {
    prodUUID    : Products : ID;
    name        : localized String;
    description : localized String;
    toProduct   : Association to one Products
                      on toProduct.ID = prodUUID;
    toCountry   : Country;
    status      : String(10);
    startDate   : Date;
    endDate     : Date;
}

entity Orders : cuid, managed {
    toProducts   : Composition of many Ord2Prod
                       on toProducts.orderID = ID;
    mrktUUID     : Markets : ID;
    toMarket     : Association to one Markets
                       on toMarket.ID = mrktUUID;
    phaseID      : Phases : ID;
    toPhase      : Association to one Phases
                       on toPhase.ID = phaseID;
    orderID      : String(10);
    description  : String;
    deliveryDate : Date;
    year         : String(4);
    netAmount    : Decimal;
    grossAmount  : Decimal;
    currency     : Currency;
}

entity Ord2Prod {
    key orderID   : cuid : ID;
    key productID : cuid : ID;
        quantity  : lib.TQuantityInt;
        phaseID   : Phases : ID;
        toProduct : Association to Products
                        on toProduct.ID = productID;
        toOrder   : Association to one Orders
                        on toOrder.ID = orderID;
        toPhase   : Association to one Phases
                        on toPhase.ID = phaseID;
}

define view OrdersPhasesVH as
    select from Phases
    where
        ID like 'O%';


//-----------------------
//Fields annotaions
//----------------------
annotate UOM with {
    msehi @(title : '{i18n>msehiUOM}');
};


annotate Products with @(title : '{i18n>productService}') {
    ID          @(title : '{i18n>productGUID}');
    description @(title : '{i18n>description}');
    prodId      @(
        title                       : '{i18n>prodID}',
        Common.FieldControl         : #Mandatory,
        Search.defaultSearchElement : true,
        Common.ValueList            : {
            CollectionPath : 'Products',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : 'prodId',
                    ValueListProperty : 'prodId'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'description',
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'toProdGroup/name',
                }
            ]
        }
    );
};

annotate Phases with @(title : '{i18n>phaseService}') {
    ID          @(title : '{i18n>phaseID}');
    name        @(title : '{i18n>phaseName}');
    description @(title : '{i18n>description}')
};


annotate Orders with @(title : '{i18n>ordersService}') {
    ID          @(UI.Hidden : true);
    orderID     @(
        title                       : '{i18n>orderID}',
        Common.FieldControl         : #ReadOnly,
        Search.defaultSearchElement : true,
        Common.ValueList            : {
            CollectionPath : 'Orders',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : 'orderID',
                    ValueListProperty : 'orderID'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'description',
                },
            ]
        }
    );
    description @(title : '{i18n>description}');
    netAmount   @(
        title               : '{i18n>netAmount}',
        Common.FieldControl : #ReadOnly,
    );
    grossAmount @(
        title               : '{i18n>grossAmount}',
        Common.FieldControl : #ReadOnly,
    );
    toProducts  @(
        title       : '{i18n>orderProdItems}',
        description : '{i18n>orderProdItems}'
    );
    phaseID     @(Common : {
        ValueListWithFixedValues : true,
        ValueList                : {
            CollectionPath : 'OrdersPhasesVH',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : 'phaseID',
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'name',
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'description',
                },
            ]
        }
    });

};

annotate Ord2Prod with {
    quantity @(Common.FieldControl : #Mandatory);
};

annotate ProductGroups with {
    name @(title : '{i18n>prodGrName}')
};

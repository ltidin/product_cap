using {db} from '../db/schema';


service ProductService {
    entity Products @(title : '{i18n>productService}')                                                                                                     as projection on db.Products;
    entity ProductGroup                                                                                                                                    as projection on db.ProductGroups;
    entity Phase                                                                                                                                           as projection on db.Phases;
    entity UOM                                                                                                                                             as projection on db.UOM;
    entity Markets                                                                                                                                         as projection on db.Markets;

    entity Orders                                                                                                        @(title : '{i18n>ordersService}') as projection on db.Orders {
        * , toProducts : redirected to Ord2Prod, case phaseID
                                                     when
                                                         'O0001'
                                                     then
                                                         0
                                                     when
                                                         'O0002'
                                                     then
                                                         2
                                                     when
                                                         'O0003'
                                                     then
                                                         3
                                                     else
                                                         1
                                                 end as phaseIcon : Integer                                              @UI.Hidden,
    } actions {
        action addProdToOrder(prodId : db.Products : prodId, quantity : db.Ord2Prod : quantity) returns Ord2Prod
    };

    entity Ord2Prod                                                                                        @(title : '{i18n>ordersService}')               as projection on db.Ord2Prod {
        * , toOrder : redirected to Orders, toProduct : redirected to Products, case phaseID
                                                                                    when
                                                                                        'P0001'
                                                                                    then
                                                                                        0
                                                                                    when
                                                                                        'P0002'
                                                                                    then
                                                                                        2
                                                                                    when
                                                                                        'P0003'
                                                                                    then
                                                                                        3
                                                                                    else
                                                                                        1
                                                                                end as phaseIcon : Integer @UI.Hidden,
    } actions {
        action addProductToOrder(prodID : db.Products : prodId, quantity : db.Ord2Prod : quantity) returns String;
    };


    view OrdersPhasesVH @(cds.redirection.target : false) as select from db.OrdersPhasesVH;
}

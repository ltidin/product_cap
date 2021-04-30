namespace lib;


type Mandt : String(3);
type TQuantityInt : Integer @(title : '{i18n>quantity}');


aspect SapDefault {
    key mandt : Mandt;
}

annotate SapDefault with {
    mandt @(UI.Hidden : true);
};


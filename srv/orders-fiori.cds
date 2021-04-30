using {ProductService} from './product-service';

annotate ProductService.Orders with @( //Header level annotations
    // List report for Orders
    UI        : {
        SelectionFields     : [
            orderID,
            phaseID
        ],
        LineItem            : [
            {
                $Type             : 'UI.DataField',
                Value             : orderID,
                ![@UI.Importance] : #High
            },
            {
                $Type             : 'UI.DataField',
                Value             : description,
                ![@UI.Importance] : #High
            },
            {
                $Type             : 'UI.DataField',
                Value             : grossAmount,
                ![@UI.Importance] : #High
            },
            {
                $Type             : 'UI.DataField',
                Value             : netAmount,
                ![@UI.Importance] : #Medium
            },
            {
                $Type             : 'UI.DataField',
                Value             : currency.code,
                ![@UI.Importance] : #Medium
            },
            {
                $Type                     : 'UI.DataField',
                Value                     : toPhase.name,
                Criticality               : phaseIcon,
                CriticalityRepresentation : #WithIcon,
            },
        ],
        PresentationVariant : {SortOrder : [{
            $Type      : 'Common.SortOrderType',
            Property   : orderID,
            Descending : false
        }], },
    },

    //Object Page
    UI        : {
        HeaderInfo                : {
            $Type          : 'UI.HeaderInfoType',
            TypeName       : '{i18n>ordersService}',
            TypeNamePlural : '{i18n>ordersServices}',
            Title          : {
                Value             : orderID,
                ![@UI.Emphasized] : true
            },
            Description    : {
                Value             : description,
                ![@UI.Emphasized] : true
            },
        },
        HeaderFacets              : [
            {
                $Type             : 'UI.ReferenceFacet',
                Target            : '@UI.FieldGroup#Description',
                Label             : '{i18n>orderDetails}',
                ![@UI.Importance] : #High
            },
            {
                $Type             : 'UI.ReferenceFacet',
                Target            : '@UI.DataPoint#NetAmount',
                ![@UI.Importance] : #High
            },
            {
                $Type             : 'UI.ReferenceFacet',
                Target            : '@UI.DataPoint#Status',
                ![@UI.Importance] : #High
            }
        ],
        FieldGroup #Description   : {
            $Type : 'UI.FieldGroupType',
            Data  : [{
                $Type : 'UI.DataField',
                Value : currency.code,
            }, ]
        },
        FieldGroup #MarketDetails : {
            $Type : 'UI.FieldGroupType',
            Data  : [
                {
                    $Type : 'UI.DataField',
                    Value : toMarket.name,
                    Label : '{i18n>marketName}',
                },
                {
                    $Type : 'UI.DataField',
                    Value : toMarket.status,
                    Label : '{i18n>marketStatus}'
                },
            ]

        },
        DataPoint #NetAmount      : {
            $Type       : 'UI.DataPointType',
            Value       : netAmount,
            Title       : '{i18n>netAmount}',
            Criticality : #Positive,
        },
        DataPoint #Status         : {
            $Type       : 'UI.DataPointType',
            Value       : toPhase.name,
            Title       : '{i18n>phaseName}',
            Criticality : phaseIcon,
        },
    },
    UI.Facets : [
        {
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>orderProdItems}',
            Target : 'toProducts/@UI.LineItem'
        },
        {
            $Type  : 'UI.CollectionFacet',
            ID     : 'OrderMarkets',
            Label  : '{i18n>marketDetails}',
            Facets : [{
                $Type  : 'UI.ReferenceFacet',
                Target : 'UI.FieldGroup#MarketDetails',
                Label  : '{i18n>marketDetails}',
            }]
        }
    ],

);

annotate db.Ord2Prod with @(
    //List report
    //Orders Items
    Capabilities : {Insertable : false},
    UI           : {LineItem : [
        {
            $Type             : 'UI.DataField',
            Value             : toProduct.prodId,
            ![@UI.Importance] : #High,
        },
        {
            $Type             : 'UI.DataField',
            Value             : quantity,
            ![@UI.Importance] : #Medium,
        },
        {
            $Type                     : 'UI.DataField',
            Value                     : toPhase.name,
            Criticality               : phaseIcon,
            CriticalityRepresentation : #WithIcon,
            ![@UI.Importance]         : #High,
        },
        {
            $Type             : 'UI.DataFieldWithUrl',
            Url               : 'https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstleyVEVO',
            Value             : toProduct.toUom.msehi,
            ![@UI.Importance] : #Medium,
        },
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'ProductService.EntityContainer/addProductToOrder',
            Label  : '{i18n>add}'
        }
    ], },
    //object Page
    UI           : {
        HeaderInfo       : {
            $Type          : 'UI.HeaderInfoType',
            TypeName       : '{i18n>productService}',
            TypeNamePlural : '{i18n>productServices}',
            ImageUrl       : toProduct.toProdGroup.imageURL,
            Title          : {
                $Type             : 'UI.DataField',
                Value             : toProduct.prodId,
                ![@UI.Importance] : #High,
            },
            Description    : {
                $Type             : 'UI.DataField',
                Value             : toProduct.description,
                ![@UI.Importance] : #Medium,
            },
        },
        HeaderFacets     : [{
            $Type             : 'UI.ReferenceFacet',
            Target            : '@UI.FieldGroup#Size',
            ![@UI.Importance] : #High,
            Label             : '{i18n>productSize}',
        }, ],
        FieldGroup #Size : {
            $Type : 'UI.FieldGroupType',
            Data  : [
                {
                    $Type : 'UI.DataField',
                    Value : toProduct.height,
                    Label : '{i18n>prodHeight}'
                },
                {
                    $Type : 'UI.DataField',
                    Value : toProduct.width,
                    Label : '{i18n>prodWidth}'
                },
                {
                    $Type : 'UI.DataField',
                    Value : toProduct.depth,
                    Label : '{i18n>prodDepth}'

                },
            ],
        },
    },
);

annotate ProductService.addProductToOrder(prodID
@(Common : {ValueListMapping : {
    Label          : '{i18n>productServices}',
    CollectionPath : 'Products',
    Parameters     : [
        {
            $Type             : 'Common.ValueListParameterInOut',
            LocalDataProperty : prodID,
            ValueListProperty : 'prodId'
        },
        {
            $Type             : 'Common.ValueListParameterDisplayOnly',
            ValueListProperty : 'description'
        },
    ]
}, }),
quantity);

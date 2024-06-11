table 6085700 "CDC Purch. Doc. Match"
{
    Caption = 'Purch. Doc. Match';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "CDC Document";
        }
        field(2; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(3; "Purch. Doc. Type"; Option)
        {
            Caption = 'Purch. Document Type';
            OptionCaption = 'Receipt,Return Shipment,Order,Return Order';
            OptionMembers = Receipt,"Return Shipment","Order","Return Order";
        }
        field(4; "Purch. Doc. No."; Code[20])
        {
            Caption = 'Purch. Document No.';
            TableRelation = IF ("Purch. Doc. Type" = CONST(Receipt)) "Purch. Rcpt. Header"
            ELSE
            IF ("Purch. Doc. Type" = CONST("Return Shipment")) "Return Shipment Header"
            ELSE
            IF ("Purch. Doc. Type" = CONST(Order)) "Purchase Header"."No." WHERE("Document Type" = CONST(Order))
            ELSE
            IF ("Purch. Doc. Type" = CONST("Return Order")) "Purchase Header"."No." WHERE("Document Type" = CONST("Return Order"));
        }
        field(5; "Purch. Line No."; Integer)
        {
            Caption = 'Purchase Line No.';
            TableRelation = IF ("Purch. Doc. Type" = CONST(Receipt)) "Purch. Rcpt. Line"."Line No." WHERE("Document No." = FIELD("Purch. Doc. No."))
            ELSE
            IF ("Purch. Doc. Type" = CONST("Return Shipment")) "Return Shipment Line"."Line No." WHERE("Document No." = FIELD("Purch. Doc. No."))
            ELSE
            IF ("Purch. Doc. Type" = CONST(Order)) "Purchase Line"."Line No." WHERE("Document Type" = CONST(Order),
                                                                                                        "Document No." = FIELD("Purch. Doc. No."))
            ELSE
            IF ("Purch. Doc. Type" = CONST("Return Order")) "Purchase Line"."Line No." WHERE("Document Type" = CONST("Return Order"),
                                                                                                                                                                                             "Document No." = FIELD("Purch. Doc. No."));
        }
        field(6; Quantity; Decimal)
        {
            BlankZero = true;
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(7; "Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
        }
        field(8; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Document Line No.", "Purch. Doc. Type", "Purch. Doc. No.", "Purch. Line No.")
        {
            Clustered = true;
            SumIndexFields = Quantity, "Direct Unit Cost";
        }
        key(Key2; "Purch. Doc. Type", "Purch. Doc. No.", "Purch. Line No.")
        {
            SumIndexFields = Quantity, "Direct Unit Cost";
        }
    }
}
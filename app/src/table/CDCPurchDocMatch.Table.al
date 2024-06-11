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
            TableRelation = if ("Purch. Doc. Type" = const(Receipt)) "Purch. Rcpt. Header"
            else
            if ("Purch. Doc. Type" = const("Return Shipment")) "Return Shipment Header"
            else
            if ("Purch. Doc. Type" = const(Order)) "Purchase Header"."No." where("Document Type" = const(Order))
            else
            if ("Purch. Doc. Type" = const("Return Order")) "Purchase Header"."No." where("Document Type" = const("Return Order"));
        }
        field(5; "Purch. Line No."; Integer)
        {
            Caption = 'Purchase Line No.';
            TableRelation = if ("Purch. Doc. Type" = const(Receipt)) "Purch. Rcpt. Line"."Line No." where("Document No." = field("Purch. Doc. No."))
            else
            if ("Purch. Doc. Type" = const("Return Shipment")) "Return Shipment Line"."Line No." where("Document No." = field("Purch. Doc. No."))
            else
            if ("Purch. Doc. Type" = const(Order)) "Purchase Line"."Line No." where("Document Type" = const(Order),
                                                                                                        "Document No." = field("Purch. Doc. No."))
            else
            if ("Purch. Doc. Type" = const("Return Order")) "Purchase Line"."Line No." where("Document Type" = const("Return Order"),
                                                                                                                                                                                             "Document No." = field("Purch. Doc. No."));
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
table 6085783 "CDC Match Tracking Spec."
{
    Caption = 'Match Tracking Specification';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "CDC Document";
        }
        field(3; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(4; "Purch. Doc. Type"; Option)
        {
            Caption = 'Purch. Document Type';
            OptionCaption = 'Receipt,Return Shipment,Order,Return Order';
            OptionMembers = Receipt,"Return Shipment","Order","Return Order";
        }
        field(5; "Purch. Doc. No."; Code[20])
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
        field(6; "Purch. Line No."; Integer)
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
        field(7; "Matched Quantity"; Decimal)
        {
            BlankZero = true;
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(8; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';
        }
        field(9; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
        field(10; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
            Editable = false;
            TableRelation = "Item Ledger Entry";
        }
        field(11; "Type Spec"; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Document,Purchase Invoice,Purchase Credit Memo,Purchase Receipt,Return Shipment,Purchase Order,Purchase Return Order';
            OptionMembers = Document,"Purchase Invoice","Purchase Credit Memo","Purchase Receipt","Return Shipment","Purchase Order","Purchase Return Order";
        }
        field(12; "Document No. Spec"; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = IF ("Type Spec" = CONST(Document)) "CDC Document"
            ELSE
            IF ("Type Spec" = CONST("Purchase Invoice")) "Purchase Header"."No." WHERE("Document Type" = CONST(Invoice))
            ELSE
            IF ("Type Spec" = CONST("Purchase Credit Memo")) "Purchase Header"."No." WHERE("Document Type" = CONST("Credit Memo"));
        }
        field(13; "Item No. Spec"; Code[250])
        {
            Caption = 'No.';
        }
        field(14; "Line No. Spec"; Integer)
        {
            BlankZero = true;
            Caption = 'Line No.';
        }
        field(15; "Description Spec"; Text[250])
        {
            Caption = 'Description';
        }
        field(16; "Quantity Spec"; Decimal)
        {
            BlankZero = true;
            Caption = 'Quantity';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document No.", "Document Line No.", "Purch. Doc. Type", "Purch. Doc. No.", "Purch. Line No.")
        {
        }
        key(Key3; "Item Ledger Entry No.")
        {
        }
        key(Key4; "Purch. Doc. No.", "Purch. Line No.", "Purch. Doc. Type", "Document No.", "Document Line No.")
        {
        }
    }
}
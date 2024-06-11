table 6085761 "CDC Purch. Doc. Match Spec."
{
    Caption = 'Match Specification';

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Document,Purchase Invoice,Purchase Credit Memo,Purchase Receipt,Return Shipment,Purchase Order,Purchase Return Order';
            OptionMembers = Document,"Purchase Invoice","Purchase Credit Memo","Purchase Receipt","Return Shipment","Purchase Order","Purchase Return Order";
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = if (Type = const(Document)) "CDC Document"
            else
            if (Type = const("Purchase Invoice")) "Purchase Header"."No." where("Document Type" = const(Invoice))
            else
            if (Type = const("Purchase Credit Memo")) "Purchase Header"."No." where("Document Type" = const("Credit Memo"));
        }
        field(3; "Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'Line No.';
        }
        field(4; "Matched Quantity"; Decimal)
        {
            Caption = 'Matched Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(5; "No."; Code[250])
        {
            Caption = 'No.';
        }
        field(6; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(7; Quantity; Decimal)
        {
            BlankZero = true;
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(8; "Direct Unit Cost"; Decimal)
        {
            BlankZero = true;
            Caption = 'Direct Unit Cost';
        }
        field(9; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(10; "Matched Direct Unit Cost"; Decimal)
        {
            BlankZero = true;
            Caption = 'Matched Direct Unit Cost';
        }
        field(11; "Matched Line Discount %"; Decimal)
        {
            Caption = 'Matched Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(28; "Line Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
        }
    }

    keys
    {
        key(Key1; Type, "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


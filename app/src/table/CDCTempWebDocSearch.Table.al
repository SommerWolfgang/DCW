table 6086009 "CDC Temp. Web Doc. Search"
{
    Caption = 'Temp. Web Doc. Search';

    fields
    {
        field(1; "Search GUID"; Guid)
        {
            Caption = 'Search GUID';
        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Posted Purch. Invoice,Posted Purch. Credit Memo,Purchase Invoice,Purchase Credit Memo';
            OptionMembers = "Posted Purch. Invoice","Posted Purch. Credit Memo","Purchase Invoice","Purchase Credit Memo";
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const("Posted Purch. Invoice")) "Purch. Inv. Header"
            else
            if (Type = const("Posted Purch. Credit Memo")) "Purch. Cr. Memo Hdr."
            else
            if (Type = const("Purchase Invoice")) "Purchase Header"."No." where("Document Type" = const(Invoice))
            else
            if (Type = const("Purchase Credit Memo")) "Purchase Header"."No." where("Document Type" = const("Credit Memo"));
        }
        field(4; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(7; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(8; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(9; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(10; "Amount Excl. VAT"; Decimal)
        {
            Caption = 'Amount Excl. VAT';
        }
        field(11; "Amount Incl. VAT"; Decimal)
        {
            Caption = 'Amount Incl. VAT';
        }
        field(80; "Dimension Code 1"; Code[20])
        {
            Caption = 'Dimension Code 1';
            TableRelation = Dimension;
        }
        field(81; "Dimension Value 1"; Code[20])
        {
            Caption = 'Dimension Value 1';
            TableRelation = "Dimension Value".Code;
        }
    }

    keys
    {
        key(Key1; "Search GUID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


table 6086005 "CDC Web Document Search"
{
    Caption = 'Web Document Search';

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Posted Purch. Invoice,Posted Purch. Credit Memo,Purchase Invoice,Purchase Credit Memo';
            OptionMembers = "Posted Purch. Invoice","Posted Purch. Credit Memo","Purchase Invoice","Purchase Credit Memo";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST ("Posted Purch. Invoice")) "Purch. Inv. Header"
            ELSE
            IF (Type = CONST ("Posted Purch. Credit Memo")) "Purch. Cr. Memo Hdr."
            ELSE
            IF (Type = CONST ("Purchase Invoice")) "Purchase Header"."No." WHERE ("Document Type" = CONST (Invoice))
            ELSE
            IF (Type = CONST ("Purchase Credit Memo")) "Purchase Header"."No." WHERE ("Document Type" = CONST ("Credit Memo"));
        }
        field(3; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(6; "External Document No."; Code[50])
        {
            Caption = 'External Document No.';
        }
        field(7; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(8; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(9; "Amount Excl. VAT"; Decimal)
        {
            Caption = 'Amount Excl. VAT';
        }
        field(10; "Amount Incl. VAT"; Decimal)
        {
            Caption = 'Amount Incl. VAT';
        }
        field(21; "Dimension Code 1"; Code[20])
        {
            Caption = 'Dimension Code 1';
            TableRelation = Dimension;
        }
        field(22; "Dimension Code 2"; Code[20])
        {
            Caption = 'Dimension Code 2';
            TableRelation = Dimension;
        }
        field(23; "Dimension Code 3"; Code[20])
        {
            Caption = 'Dimension Code 3';
            TableRelation = Dimension;
        }
        field(24; "Dimension Code 4"; Code[20])
        {
            Caption = 'Dimension Code 4';
            TableRelation = Dimension;
        }
        field(25; "Dimension Code 5"; Code[20])
        {
            Caption = 'Dimension Code 5';
            TableRelation = Dimension;
        }
        field(26; "Dimension Code 6"; Code[20])
        {
            Caption = 'Dimension Code 6';
            TableRelation = Dimension;
        }
        field(27; "Dimension Code 7"; Code[20])
        {
            Caption = 'Dimension Code 7';
            TableRelation = Dimension;
        }
        field(28; "Dimension Code 8"; Code[20])
        {
            Caption = 'Dimension Code 8';
            TableRelation = Dimension;
        }
        field(31; "Dimension Value 1"; Code[20])
        {
            Caption = 'Dimension Value 1';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code" = FIELD ("Dimension Code 1"));
        }
        field(32; "Dimension Value 2"; Code[20])
        {
            Caption = 'Dimension Value 2';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code" = FIELD ("Dimension Code 2"));
        }
        field(33; "Dimension Value 3"; Code[20])
        {
            Caption = 'Dimension Value 3';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code" = FIELD ("Dimension Code 3"));
        }
        field(34; "Dimension Value 4"; Code[20])
        {
            Caption = 'Dimension Value 4';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code" = FIELD ("Dimension Code 4"));
        }
        field(35; "Dimension Value 5"; Code[20])
        {
            Caption = 'Dimension Value 5';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code" = FIELD ("Dimension Code 5"));
        }
        field(36; "Dimension Value 6"; Code[20])
        {
            Caption = 'Dimension Value 6';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code" = FIELD ("Dimension Code 6"));
        }
        field(37; "Dimension Value 7"; Code[20])
        {
            Caption = 'Dimension Value 7';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code" = FIELD ("Dimension Code 7"));
        }
        field(38; "Dimension Value 8"; Code[20])
        {
            Caption = 'Dimension Value 8';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code" = FIELD ("Dimension Code 8"));
        }
    }

    keys
    {
        key(Key1; Type, "No.", "User ID")
        {
            Clustered = true;
        }
        key(Key2; Type, "User ID", Name, "Document Date")
        {
        }
    }

    fieldgroups
    {
    }
}


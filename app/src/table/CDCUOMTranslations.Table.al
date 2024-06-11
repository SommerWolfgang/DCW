table 6085782 "CDC UOM Translations"
{
    Caption = 'Unit of Measure Translations';

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(3; "Translate From"; Text[200])
        {
            Caption = 'Translate From';
            NotBlank = true;
        }
        field(10; "Translate to UOM Code"; Code[10])
        {
            Caption = 'Translate to UOM Code';
            TableRelation = "Unit of Measure";
        }
        field(11; "Case-sensitive"; Boolean)
        {
            Caption = 'Case-sensitive';
        }
    }

    keys
    {
        key(Key1; "Vendor No.", "Item No.", "Translate From")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


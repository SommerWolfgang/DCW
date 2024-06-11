table 6085752 "CDC Posted Dtld. Appvl. Entry"
{
    Caption = 'Posted Detailed Approval Entry';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; "Approval Group Code"; Code[10])
        {
            Caption = 'Approval Group Code';
            TableRelation = "CDC Approval Group".Code;
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
        field(11; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(13; Approved; Boolean)
        {
            Caption = 'Approved';
        }
        field(14; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
    }

    keys
    {
        key(Key1; "Table ID", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


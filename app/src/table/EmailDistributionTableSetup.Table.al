table 12032501 "Email Distribution Table Setup"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland
    // 
    // #DCW113.00:T102 25.10.18 DEMSR.KHS
    //   Update Table Relation for Status fields

    Caption = 'Email Distrib. Table Setup';

    fields
    {
        field(10; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(20; "Record ID"; RecordID)
        {
            Caption = 'Record ID';
        }
        field(50; "Email Distribution Code"; Code[10])
        {
            Caption = 'Email Distribution Code';
            TableRelation = "Email Distribution Code".Code;
        }
        field(500; "From Status"; Code[20])
        {
            Caption = 'From Status';
            TableRelation = "Lot-/ Serial No. Status";
        }
        field(510; "To Status"; Code[20])
        {
            Caption = 'To Status';
            TableRelation = "Lot-/ Serial No. Status";
        }
    }

    keys
    {
        key(Key1; "Table ID", "Record ID", "From Status", "To Status")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


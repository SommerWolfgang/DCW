table 12032501 "Email Distribution Table Setup"
{
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
        }
        field(500; "From Status"; Code[20])
        {
            Caption = 'From Status';
        }
        field(510; "To Status"; Code[20])
        {
            Caption = 'To Status';
        }
    }

    keys
    {
        key(Key1; "Table ID", "Record ID", "From Status", "To Status")
        {
            Clustered = true;
        }
    }
}
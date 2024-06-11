table 6086379 "CEM User Responsibility"
{
    Caption = 'User Responsibility';
    Permissions = TableData "CEM User Responsibility" = rimd;

    fields
    {
        field(1; "Responsible User ID"; Code[50])
        {
            Caption = 'Responsible User ID';
            TableRelation = "CDC Continia User Setup";
        }
        field(2; "User ID sharing responsibility"; Code[50])
        {
            Caption = 'User ID sharing responsibility';
            TableRelation = "CDC Continia User Setup";
        }
    }

    keys
    {
        key(Key1; "Responsible User ID", "User ID sharing responsibility")
        {
            Clustered = true;
        }
        key(Key2; "User ID sharing responsibility")
        {
        }
    }

    fieldgroups
    {
    }
}


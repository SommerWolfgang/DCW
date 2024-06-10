table 6086235 "CTS-CDN DC Templ. Profile Rel."
{
    Caption = 'Document Capture Network Profile Relation';

    fields
    {
        field(1; "Document Category"; Code[20])
        {
            Caption = 'Document Category';
        }
        field(2; "XML Master Template"; Code[20])
        {
            Caption = 'XML Master Template';
        }
        field(3; "Network Profile ID"; Integer)
        {
            Caption = 'Network Profile ID';
            TableRelation = "CTS-CDN Network Profile"."System ID";
        }
    }

    keys
    {
        key(Key1; "Document Category", "XML Master Template", "Network Profile ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


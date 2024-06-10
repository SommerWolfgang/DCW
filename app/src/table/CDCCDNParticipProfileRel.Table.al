table 6086207 "CDC CDN Particip. Profile Rel."
{
    Caption = 'Participation Profile Relation';

    fields
    {
        field(1; "Network Name"; Text[30])
        {
            Caption = 'Network Name';
            TableRelation = "CDC CDN Network";
        }
        field(2; "Participation Identifier Type"; Integer)
        {
            Caption = 'Participation Identifier Type';
        }
        field(3; "Participation Identifier Value"; Text[50])
        {
            Caption = 'Participation Identifier Value';
        }
        field(4; "Profile System ID"; Integer)
        {
            Caption = 'Profile System ID';
        }
        field(5; "Profile Direction"; Option)
        {
            Caption = 'Profile Direction';
            OptionCaption = 'Outbound,Inbound,Both';
            OptionMembers = Outbound,Inbound,Both;
        }
    }

    keys
    {
        key(Key1; "Network Name", "Participation Identifier Type", "Participation Identifier Value", "Profile System ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


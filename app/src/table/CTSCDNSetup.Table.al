table 6086220 "CTS-CDN Setup"
{
    Caption = 'Continia Delivery Network Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Use Participation Details"; Boolean)
        {
            Caption = 'Use Participation Details';
        }
        field(10; "Company Currency Code"; Code[10])
        {
            Caption = 'Company Currency Code (ISO)';
        }
        field(11; "Company Country Code"; Code[10])
        {
            Caption = 'Company Country Code (ISO)';
        }
        field(20; "Use Item Attributes"; Boolean)
        {
            Caption = 'Use Item Attributes';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


table 6086204 "CDC CDN Network"
{
    Caption = 'Continia Delivery Network Subnetwork';

    fields
    {
        field(1; Name; Text[30])
        {
            Caption = 'Network Name';
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


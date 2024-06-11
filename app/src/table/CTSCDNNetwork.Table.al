table 6086221 "CTS-CDN Network"
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
        field(3; "Display Name"; Text[50])
        {
            Caption = 'Display Name';
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


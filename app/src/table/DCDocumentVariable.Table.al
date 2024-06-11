table 12032010 "DC - Document Variable"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland
    // cc|document configurator (CCDC)

    Caption = 'Document Variable';

    fields
    {
        field(1; Variable; Code[20])
        {
            Caption = 'Variable';
        }
        field(2; Value; Text[250])
        {
            Caption = 'Value';
        }
        field(3; "Decimal Value"; Decimal)
        {
            Caption = 'Decimal Value';
        }
    }

    keys
    {
        key(Key1; Variable)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


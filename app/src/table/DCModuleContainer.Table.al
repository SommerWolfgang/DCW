table 12032050 "DC - Module Container"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland
    // cc|document configurator (CCDC)

    Caption = 'Document Configurator Module Container';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Module Code"; Code[10])
        {
            Caption = 'Module Code';
        }
        field(10; "Serialized Variables"; BLOB)
        {
            Caption = 'Serialized Variables';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


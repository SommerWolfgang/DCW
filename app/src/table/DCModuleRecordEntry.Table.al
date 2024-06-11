table 12032055 "DC - Module Record Entry"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland
    // cc|document configurator (CCDC)

    Caption = 'Document Configurator Module Record Entry';

    fields
    {
        field(1; "Module Code"; Code[20])
        {
        }
        field(2; "Entry No."; BigInteger)
        {
        }
        field(20; "Code 1"; Code[20])
        {
        }
        field(21; "Code 2"; Code[20])
        {
        }
        field(22; "Code 3"; Code[20])
        {
        }
        field(30; "Integer 1"; Integer)
        {
        }
        field(31; "Integer 2"; Integer)
        {
        }
        field(32; "Integer 3"; Integer)
        {
        }
        field(40; "Decimal 1"; Decimal)
        {
        }
        field(41; "Decimal 2"; Decimal)
        {
        }
        field(42; "Decimal 3"; Decimal)
        {
        }
        field(43; "Decimal 4"; Decimal)
        {
        }
        field(44; "Decimal 5"; Decimal)
        {
        }
        field(45; "Decimal 6"; Decimal)
        {
        }
        field(50; "Text 1"; Text[100])
        {
        }
        field(51; "Text 2"; Text[100])
        {
        }
        field(52; "Text 3"; Text[100])
        {
        }
        field(60; "Date 1"; Date)
        {
        }
        field(61; "Date 2"; Date)
        {
        }
        field(62; "Date 3"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Module Code", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


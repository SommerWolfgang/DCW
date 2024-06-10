table 6085574 "CDC Scanner"
{
    Caption = 'Scanner';

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(Key1; "Code", Name)
        {
            Clustered = true;
        }
    }
}
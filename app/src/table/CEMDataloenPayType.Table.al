table 6086343 "CEM Dataloen Pay Type"
{
    Caption = 'Dataloen Pay Type';

    fields
    {
        field(1; "No."; Code[10])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            NotBlank = true;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
}
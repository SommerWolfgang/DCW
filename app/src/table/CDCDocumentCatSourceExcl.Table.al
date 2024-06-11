table 6085598 "CDC Document Cat. Source Excl."
{
    Caption = 'Source Exclusion';

    fields
    {
        field(1; "Document Category Code"; Code[10])
        {
            Caption = 'Category Code';
        }
        field(4; "Source Record ID Tree ID"; Integer)
        {
            Caption = 'Source Record ID Tree ID';
        }
    }

    keys
    {
        key(Key1; "Document Category Code", "Source Record ID Tree ID")
        {
            Clustered = true;
        }
    }

    procedure GetSourceID(): Text[200]
    begin
    end;

    procedure SetSourceID(SourceID: Text[200])
    begin
    end;

    procedure GetSourceName(): Text[50]
    begin
    end;
}
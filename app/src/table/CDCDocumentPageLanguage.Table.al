table 6085605 "CDC Document Page Language"
{
    Caption = 'Document Page Language';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "CDC Document";
        }
        field(2; "Page No."; Integer)
        {
            Caption = 'Page No.';
        }
        field(3; Language; Text[50])
        {
            Caption = 'Language';
        }
        field(4; "No. of Words"; Integer)
        {
            Caption = 'No. of Words';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Page No.", Language)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Word: Record "CDC Document Word";
        Value: Record "CDC Document Value";
    begin
        Word.SetRange("Document No.", "Document No.");
        Word.SetRange("Page No.", "Page No.");
        Word.DeleteAll(true);

        Value.SetRange("Document No.", "Document No.");
        Value.SetRange("Page No.", "Page No.");
        Value.DeleteAll(true);
    end;
}


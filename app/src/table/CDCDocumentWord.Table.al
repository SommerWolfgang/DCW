table 6085592 "CDC Document Word"
{
    Caption = 'Document Word';

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
            TableRelation = "CDC Document Page"."Page No." WHERE ("Document No." = FIELD ("Document No."));
        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(4; Word; Text[200])
        {
            Caption = 'Word';
        }
        field(5; Top; Integer)
        {
            Caption = 'Top';
        }
        field(6; Left; Integer)
        {
            Caption = 'Left';
        }
        field(7; Bottom; Integer)
        {
            Caption = 'Bottom';
        }
        field(8; Right; Integer)
        {
            Caption = 'Right';
        }
        field(9; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Text,Barcode';
            OptionMembers = Text,Barcode;
        }
        field(10; "Barcode Type"; Code[20])
        {
            Caption = 'Barcode Type';
        }
        field(11; Data; BLOB)
        {
            Caption = 'Data';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Page No.", "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document No.", "Page No.", Bottom)
        {
        }
        key(Key3; "Document No.", "Page No.", Left)
        {
        }
        key(Key4; "Document No.", "Page No.", Top, Left)
        {
        }
        key(Key5; Word, "Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        Word: Record "CDC Document Word";
    begin
        if "Entry No." = 0 then begin
            Word.SetRange("Document No.", "Document No.");
            Word.SetRange("Page No.", "Page No.");
            if Word.FindLast then
                "Entry No." := Word."Entry No." + 1
            else
                "Entry No." := 1;
        end;
    end;
}


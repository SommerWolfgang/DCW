table 6086200 "CDC XML Buffer"
{
    Caption = 'XML Buffer';

    fields
    {
        field(1; "Document No."; Code[50])
        {
            Caption = 'Document No.';
        }
        field(2; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Element,Attribute,Processing Instruction';
            OptionMembers = " ",Element,Attribute,"Processing Instruction";
        }
        field(4; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(5; Path; Text[250])
        {
            Caption = 'Path';
        }
        field(6; Value; Text[250])
        {
            Caption = 'Value';
        }
        field(7; Depth; Integer)
        {
            Caption = 'Depth';
        }
        field(8; "Parent Entry No."; Integer)
        {
            Caption = 'Parent Entry No.';
        }
        field(9; "Data Type"; Option)
        {
            Caption = 'Data Type';
            OptionCaption = 'Text,Date,Decimal,DateTime';
            OptionMembers = Text,Date,Decimal,DateTime;
        }
        field(10; "Node Number"; Integer)
        {
            Caption = 'Node Number';
        }
        field(11; Namespace; Text[250])
        {
            Caption = 'Namespace';
        }
        field(12; "Import ID"; Guid)
        {
            Caption = 'Import ID';
        }
        field(13; "Value BLOB"; BLOB)
        {
            Caption = 'Value BLOB';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document No.", "Parent Entry No.", Type, "Node Number")
        {
        }
        key(Key3; Value, "Document No.")
        {
        }
    }

    fieldgroups
    {
    }


    procedure LoadFromStream(XmlStream: InStream)
    begin
    end;


    procedure SetValueWithoutModifying(NewValue: Text[1024])
    var
        Stream: OutStream;
    begin
        Clear("Value BLOB");
        Value := CopyStr(NewValue, 1, MaxStrLen(Value));
        if StrLen(NewValue) <= MaxStrLen(Value) then
            exit; // No need to store anything in the blob
        if NewValue = '' then
            exit;

        "Value BLOB".CreateOutStream(Stream, TEXTENCODING::Windows);
        Stream.WriteText(NewValue);
    end;
}


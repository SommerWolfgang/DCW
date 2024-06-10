table 6086352 "CEM Field Translation"
{
    Caption = 'Field Translation';
    DataCaptionFields = "Field Type Code", "Language Code";

    fields
    {
        field(1; "Field Type Code"; Code[20])
        {
            Caption = 'Field Type Code';
            TableRelation = "CEM Field Type";
        }
        field(2; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            NotBlank = true;
            TableRelation = Language;
        }
        field(10; Translation; Text[80])
        {
            Caption = 'Translation';
        }
    }

    keys
    {
        key(Key1; "Field Type Code", "Language Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        UpdateFieldType;
    end;

    trigger OnInsert()
    begin
        UpdateFieldType;
    end;

    trigger OnModify()
    begin
        UpdateFieldType;
    end;

    local procedure UpdateFieldType()
    var
        FieldType: Record "CEM Field Type";
    begin
        if FieldType.Get("Field Type Code") then begin
            FieldType."Last Update Date/Time" := CurrentDateTime;
            FieldType.Modify;
        end;
    end;
}


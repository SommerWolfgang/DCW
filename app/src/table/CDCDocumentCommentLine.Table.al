table 6085577 "CDC Document Comment Line"
{
    Caption = 'Document Comment Line';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
        }
        field(2; "No."; Code[50])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            Editable = false;
            OptionCaption = 'User,Status Code,,,,,Other,Auto Delegate';
            OptionMembers = User,"Status Code",,,,,Other,"Auto Delegate";
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(7; "Creation Date/Time"; DateTime)
        {
            Caption = 'Date/Time';
            Editable = false;
        }
        field(8; Comment; Text[250])
        {
            Caption = 'Comment';
        }
        field(9; Date; Date)
        {
            Caption = 'Date';
        }
        field(10; "Table Name"; Text[80])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Table),
                                                                           "Object ID" = FIELD("Table ID")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Table ID", "No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField(Type, Type::User);
    end;

    trigger OnInsert()
    var
        DocumentCommentLine: Record "CDC Document Comment Line";
        NextLineNo: Integer;
    begin
        if "Line No." = 0 then begin
            DocumentCommentLine.SetRange("Table ID", "Table ID");
            DocumentCommentLine.SetRange("No.", "No.");
            if DocumentCommentLine.FindLast then
                NextLineNo := DocumentCommentLine."Line No." + 10000
            else
                NextLineNo := 10000;

            "Line No." := NextLineNo;
        end;

        "User ID" := UserId;
        Type := Type::User;
        "Creation Date/Time" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        TestField(Type, Type::User);
    end;

    trigger OnRename()
    begin
        Error(Text001, TableCaption);
    end;

    var
        Text001: Label 'You cannot rename a %1.';


    procedure SetUpNewLine()
    var
        DocumentCommentLine: Record "CDC Document Comment Line";
    begin
        DocumentCommentLine.SetRange("Table ID", "Table ID");
        DocumentCommentLine.SetRange("No.", "No.");
        DocumentCommentLine.SetRange(Date, WorkDate);
        if DocumentCommentLine.IsEmpty then
            Date := WorkDate;
    end;
}


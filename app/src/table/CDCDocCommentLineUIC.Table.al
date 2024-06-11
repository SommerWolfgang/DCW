table 6085604 "CDC Doc. Comment Line (UIC)"
{
    Caption = 'Document Comment Line (Unidentified Company)';
    DataPerCompany = false;

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
            OptionCaption = 'User,Status Code,,,,,Other';
            OptionMembers = User,"Status Code",,,,,Other;
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
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
        DocumentCommentLineUIC: Record "CDC Doc. Comment Line (UIC)";
        NextLineNo: Integer;
    begin
        if "Line No." = 0 then begin
            DocumentCommentLineUIC.SetRange("Table ID", "Table ID");
            DocumentCommentLineUIC.SetRange("No.", "No.");
            if DocumentCommentLineUIC.FindLast then
                NextLineNo := DocumentCommentLineUIC."Line No." + 10000
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
}


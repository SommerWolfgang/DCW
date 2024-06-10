table 12032006 "DC - Document Layout Variable"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland
    // cc|document configurator (CCDC)

    Caption = 'Document Layout Variable';

    fields
    {
        field(1; "Layout No."; Code[10])
        {
            Caption = 'Layout No.';
            TableRelation = "DC - Document Layout"."No.";
        }
        field(2; "Layout Line No."; Integer)
        {
            Caption = 'Layout Line No.';
            TableRelation = "DC - Document Layout Line"."Line No." WHERE("Layout No." = FIELD("Layout No."));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Value,Caption,Formula,System,Record ID,Text';
            OptionMembers = Value,Caption,Formula,System,"Record ID",Text;

            trigger OnValidate()
            begin
                if Type = Type::Value then
                    Formula := '';

                if Type = Type::Caption then
                    Formula := '';

                if Type = Type::Formula then begin
                    "Table No." := 0;
                    "Field No." := 0;
                    CalcFields("Table Name");
                    CalcFields("Field Name");
                end;

                if Type = Type::Text then begin
                    "Table No." := 0;
                    "Field No." := 0;
                    CalcFields("Table Name");
                    CalcFields("Field Name");
                end;
            end;
        }
        field(5; "Table No."; Integer)
        {
            Caption = 'Table No.';

            trigger OnLookup()
            var
                ConfiguratorDocMng: Codeunit "DC - Management";
                ObjectID: Integer;
            begin
                ObjectID := ConfiguratorDocMng.LookupObject('T');

                if ObjectID <> 0 then
                    Validate("Table No.", ObjectID);
            end;

            trigger OnValidate()
            begin
                CalcFields("Table Name");
            end;
        }
        field(6; "Table Name"; Text[30])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Table),
                                                                        "Object ID" = FIELD("Table No.")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Field No."; Integer)
        {
            Caption = 'Field No.';
            NotBlank = true;

            trigger OnLookup()
            var
                ConfiguratorDocMng: Codeunit "DC - Management";
                FieldID: Integer;
            begin
                FieldID := ConfiguratorDocMng.LookupField("Table No.");

                if FieldID <> 0 then
                    Validate("Field No.", FieldID);
            end;

            trigger OnValidate()
            begin
                CalcFields("Field Name");
            end;
        }
        field(8; "Field Name"; Text[30])
        {
            CalcFormula = Lookup(Field.FieldName WHERE(TableNo = FIELD("Table No."),
                                                        "No." = FIELD("Field No.")));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; Variable; Text[20])
        {
            Caption = 'Variable';
        }
        field(10; "Format String"; Text[100])
        {
            Caption = 'Format String';
        }
        field(12; "Last Record"; Boolean)
        {
            Caption = 'Last Record';
        }
        field(13; Formula; Text[250])
        {
            Caption = 'Formula';

            trigger OnValidate()
            begin
                if Formula <> '' then
                    TestField(Type, Type::Formula);
            end;
        }
        field(14; "System Value"; Option)
        {
            Caption = 'System Value';
            OptionCaption = ' ,User ID,Today,Workdate,User Language,Time,Company Name';
            OptionMembers = " ","User ID",Today,Workdate,"User Language",Time,"Company Name";
        }
        field(15; Text; Text[250])
        {
            Caption = 'Text';

            trigger OnValidate()
            begin
                if Formula <> '' then
                    TestField(Type, Type::Text);
            end;
        }
        field(50; "No. of Filters"; Integer)
        {
            CalcFormula = Count("DC - Document Layout Filter" WHERE("Layout No." = FIELD("Layout No."),
                                                                     "Layout Line No." = FIELD("Layout Line No."),
                                                                     "Layout Criteria Line No." = CONST(0),
                                                                     "Layout Field Line No." = CONST(0),
                                                                     "Layout Variable Line No." = FIELD("Line No."),
                                                                     "Layout Codeunit Line No." = CONST(0)));
            Caption = 'No. of Filters';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "No. of Criterias"; Integer)
        {
            CalcFormula = Count("DC - Document Layout Criterion" WHERE("Layout No." = FIELD("Layout No."),
                                                                        "Layout Line No." = FIELD("Layout Line No."),
                                                                        "Layout Field Line No." = CONST(0),
                                                                        "Layout Variable Line No." = FIELD("Line No."),
                                                                        "Layout Codeunit Line No." = CONST(0)));
            Caption = 'No. of Criteria';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Layout No.", "Layout Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        DocumentLayoutCriteria: Record "DC - Document Layout Criterion";
        DocumentLayoutFilter: Record "DC - Document Layout Filter";
        DocConfMng: Codeunit "DC - Management";
    begin
        DocConfMng.OnDeleteCode("Layout No.");

        DocumentLayoutFilter.SetRange("Layout No.", "Layout No.");
        DocumentLayoutFilter.SetRange("Layout Line No.", "Layout Line No.");
        DocumentLayoutFilter.SetRange("Layout Field Line No.", 0);
        DocumentLayoutFilter.SetRange("Layout Variable Line No.", "Line No.");
        DocumentLayoutFilter.SetRange("Layout Codeunit Line No.", 0);
        DocumentLayoutFilter.DeleteAll(true);

        DocumentLayoutCriteria.SetRange("Layout No.", "Layout No.");
        DocumentLayoutCriteria.SetRange("Layout Line No.", "Layout Line No.");
        DocumentLayoutCriteria.SetRange("Layout Field Line No.", 0);
        DocumentLayoutCriteria.SetRange("Layout Variable Line No.", "Line No.");
        DocumentLayoutCriteria.SetRange("Layout Codeunit Line No.", 0);
        DocumentLayoutCriteria.DeleteAll(true);
    end;

    trigger OnInsert()
    var
        DocConfMng: Codeunit "DC - Management";
    begin
        DocConfMng.OnInsertCode("Layout No.");
    end;

    trigger OnModify()
    var
        DocConfMng: Codeunit "DC - Management";
    begin
        DocConfMng.OnModifyCode("Layout No.");
    end;


    procedure Caption(): Text[120]
    var
        DocumentLayoutLine: Record "DC - Document Layout Line";
    begin
        if GetFilters = '' then
            exit('');

        if not DocumentLayoutLine.Get("Layout No.", "Layout Line No.") then
            exit('');

        exit(StrSubstNo('%1 %2', "Layout No.", DocumentLayoutLine.Description));
    end;


    procedure IsNumeric(): Boolean
    var
        DCMgt: Codeunit "DC - Management";
    begin
        case Type of
            Type::Formula:
                exit(true);
            Type::Value:
                exit(DCMgt.CheckIfTableFieldIsNumeric("Table No.", "Field No."));
            else
                exit(false);
        end;
    end;
}


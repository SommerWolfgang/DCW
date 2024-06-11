table 12032005 "DC - Document Layout Filter"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland
    // cc|document configurator (CCDC)

    Caption = 'Document Layout Filter';

    fields
    {
        field(1; "Layout No."; Code[10])
        {
            Caption = 'Layout No.';
            NotBlank = true;
            TableRelation = "DC - Document Layout"."No.";
        }
        field(2; "Layout Line No."; Integer)
        {
            Caption = 'Layout Line No.';
            NotBlank = true;
            TableRelation = "DC - Document Layout Line"."Line No." where("Layout No." = field("Layout No."));
        }
        field(3; "Layout Criteria Line No."; Integer)
        {
            Caption = 'Layout Criteria Line No.';
            TableRelation = "DC - Document Layout Criterion"."Line No." where("Layout No." = field("Layout No."),
                                                                               "Layout Line No." = field("Layout Line No."),
                                                                               "Layout Field Line No." = field("Layout Field Line No."),
                                                                               "Layout Variable Line No." = field("Layout Variable Line No."),
                                                                               "Layout Codeunit Line No." = field("Layout Codeunit Line No."));
        }
        field(4; "Layout Field Line No."; Integer)
        {
            Caption = 'Layout Field Line No.';
            TableRelation = "DC - Document Layout Field"."Line No." where("Layout No." = field("Layout No."),
                                                                           "Layout Line No." = field("Layout Line No."));
        }
        field(5; "Layout Variable Line No."; Integer)
        {
            Caption = 'Layout Variable Line No.';
            TableRelation = "DC - Document Layout Variable"."Line No." where("Layout No." = field("Layout No."),
                                                                              "Layout Line No." = field("Layout Line No."));
        }
        field(6; "Layout Codeunit Line No."; Integer)
        {
            Caption = 'Layout Codeunit Line No.';
            TableRelation = "DC - Document Layout Codeunit"."Line No." where("Layout No." = field("Layout No."),
                                                                              "Layout Line No." = field("Layout Line No."));
        }
        field(7; "Table No."; Integer)
        {
            Caption = 'Table No.';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));
        }
        field(8; "Field No."; Integer)
        {
            Caption = 'Field No.';
            NotBlank = true;
        }
        field(9; "Field Name"; Text[30])
        {
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Table No."), "No." = field("Field No.")));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Filter Type"; Option)
        {
            Caption = 'Filter Type';
            OptionCaption = 'Value,Text,System,Date Range';
            OptionMembers = Value,Text,System,"Date Range";

            trigger OnValidate()
            begin
                if "Filter Type" = "Filter Type"::Value then
                    Text := '';

                if "Filter Type" <> "Filter Type"::Value then begin
                    "Filter Field No." := 0;
                    CalcFields("Filter Field Name");
                end;

                if "Filter Type" <> "Filter Type"::System then begin
                    "Filter Field No." := 0;
                    CalcFields("Filter Field Name");
                    Text := '';
                end;

                if "Filter Type" <> "Filter Type"::"Date Range" then begin
                    "Filter Field No." := 0;
                    CalcFields("Filter Field Name");
                    Text := '';
                end;
            end;
        }
        field(11; "Filter Table No."; Integer)
        {
            Caption = 'Filter Table No.';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));
        }
        field(12; "Filter Field No."; Integer)
        {
            Caption = 'Filter Field No.';
        }
        field(13; "Filter Field Name"; Text[30])
        {
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Filter Table No."),
                                                        "No." = field("Filter Field No.")));
            Caption = 'Filter Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; Text; Text[250])
        {
            Caption = 'Text';

            trigger OnValidate()
            begin
                if Text <> '' then
                    TestField("Filter Type", "Filter Type"::Text);
            end;
        }
        field(15; "System Value"; Option)
        {
            Caption = 'System Value';
            OptionCaption = ' ,User ID,Today,Workdate,User Language,Time,Company Name';
            OptionMembers = " ","User ID",Today,Workdate,"User Language",Time,"Company Name";
        }
        field(16; "Start Date Formula"; DateFormula)
        {
            Caption = 'Start Date Formula';

            trigger OnValidate()
            begin
                TestField("Filter Type", "Filter Type"::"Date Range");
            end;
        }
        field(17; "End Date Formula"; DateFormula)
        {
            Caption = 'End Date Formula';

            trigger OnValidate()
            begin
                TestField("Filter Type", "Filter Type"::"Date Range");
            end;
        }
    }

    keys
    {
        key(Key1; "Layout No.", "Layout Line No.", "Layout Criteria Line No.", "Layout Field Line No.", "Layout Variable Line No.", "Layout Codeunit Line No.", "Field No.")
        {
            Clustered = true;
        }
    }

    procedure Caption(): Text[120]
    begin
    end;

    procedure InitTableNo(): Integer
    begin
    end;
}
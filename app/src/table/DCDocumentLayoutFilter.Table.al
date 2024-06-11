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
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Table No."),
                                                        "No." = field("Field No.")));
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
        }
        field(17; "End Date Formula"; DateFormula)
        {
            Caption = 'End Date Formula';
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
    var
        DocumentLayoutLine: Record "DC - Document Layout Line";
    begin
        if GetFilters = '' then
            exit('');

        if not DocumentLayoutLine.Get("Layout No.", "Layout Line No.") then
            exit('');

        exit(StrSubstNo('%1 %2', "Layout No.", DocumentLayoutLine.Description));
    end;


    procedure InitTableNo(): Integer
    var
        DocumentLayout: Record "DC - Document Layout";
        DocumentLayoutCriteria: Record "DC - Document Layout Criterion";
        DocumentLayoutField: Record "DC - Document Layout Field";
        DocumentLayoutLine: Record "DC - Document Layout Line";
        DocumentLayoutAction: Record "DC - Document Layout Variable";
    begin
        // Filter Directly on Document Layout Line
        if ("Layout Field Line No." = 0) and ("Layout Criteria Line No." = 0) and
           ("Layout Variable Line No." = 0) and ("Layout Codeunit Line No." = 0) then begin
            // Table No.
            DocumentLayoutLine.Get("Layout No.", "Layout Line No.");
            "Table No." := DocumentLayoutLine."Table No.";
            // Filter Table No.
            DocumentLayoutLine.Get("Layout No.", "Layout Line No.");
            if DocumentLayoutLine."Parent Line No." <> 0 then begin
                DocumentLayoutLine.Get("Layout No.", DocumentLayoutLine."Parent Line No.");
                "Filter Table No." := DocumentLayoutLine."Table No.";
            end else begin
                DocumentLayout.Get("Layout No.");
                DocumentLayout.TestField("Top DataItem Table No.");
                "Filter Table No." := DocumentLayout."Top DataItem Table No.";
            end;
        end;

        // Filter for Document Line Criterias
        if ("Layout Field Line No." = 0) and ("Layout Criteria Line No." <> 0) and
           ("Layout Variable Line No." = 0) and ("Layout Codeunit Line No." = 0) then begin
            // Table No.
            DocumentLayoutCriteria.Get("Layout No.", "Layout Line No.", "Layout Field Line No.", 0, 0, "Layout Criteria Line No.");
            "Table No." := DocumentLayoutCriteria."Table No.";
            // Filter Table No.
            DocumentLayoutLine.Get("Layout No.", "Layout Line No.");
            if DocumentLayoutLine."Parent Line No." <> 0 then begin
                DocumentLayoutLine.Get("Layout No.", DocumentLayoutLine."Parent Line No.");
                "Filter Table No." := DocumentLayoutLine."Table No.";
            end else begin
                DocumentLayout.Get("Layout No.");
                DocumentLayout.TestField("Top DataItem Table No.");
                "Filter Table No." := DocumentLayout."Top DataItem Table No.";
            end;
        end;

        // Filter for Document Fields
        if ("Layout Field Line No." <> 0) and ("Layout Criteria Line No." = 0) and
           ("Layout Variable Line No." = 0) and ("Layout Codeunit Line No." = 0) then begin
            // Table No.
            DocumentLayoutField.Get("Layout No.", "Layout Line No.", "Layout Field Line No.");
            "Table No." := DocumentLayoutField."Table No.";
            // Filter Table No.
            DocumentLayoutLine.Get("Layout No.", "Layout Line No.");
            "Filter Table No." := DocumentLayoutLine."Table No.";
        end;

        // Filter for Document Field Criterias
        if ("Layout Field Line No." <> 0) and ("Layout Criteria Line No." <> 0) and
           ("Layout Variable Line No." = 0) and ("Layout Codeunit Line No." = 0) then begin
            // Table No.
            DocumentLayoutCriteria.Get("Layout No.", "Layout Line No.", "Layout Field Line No.", 0, 0, "Layout Criteria Line No.");
            "Table No." := DocumentLayoutCriteria."Table No.";
            // Filter Table No.
            DocumentLayoutLine.Get("Layout No.", "Layout Line No.");
            "Filter Table No." := DocumentLayoutLine."Table No.";
        end;

        // Filter for Document Variables
        if ("Layout Field Line No." = 0) and ("Layout Criteria Line No." = 0) and
           ("Layout Variable Line No." <> 0) and ("Layout Codeunit Line No." = 0) then begin
            // Table No.
            DocumentLayoutAction.Get("Layout No.", "Layout Line No.", "Layout Variable Line No.");
            "Table No." := DocumentLayoutAction."Table No.";
            // Filter Table No.
            DocumentLayoutLine.Get("Layout No.", "Layout Line No.");
            "Filter Table No." := DocumentLayoutLine."Table No.";
        end;

        // Filter for Document Variable Criterias
        if ("Layout Field Line No." = 0) and ("Layout Criteria Line No." <> 0) and
           ("Layout Variable Line No." <> 0) and ("Layout Codeunit Line No." = 0) then begin
            // Table No.
            DocumentLayoutCriteria.Get("Layout No.", "Layout Line No.", 0, "Layout Variable Line No.", 0, "Layout Criteria Line No.");
            "Table No." := DocumentLayoutCriteria."Table No.";
            // Filter Table No.
            DocumentLayoutLine.Get("Layout No.", "Layout Line No.");
            "Filter Table No." := DocumentLayoutLine."Table No.";
        end;
    end;
}


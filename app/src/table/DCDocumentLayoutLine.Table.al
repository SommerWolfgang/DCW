table 12032002 "DC - Document Layout Line"
{
    Caption = 'Document Layout Line';

    fields
    {
        field(1; "Layout No."; Code[10])
        {
            Caption = 'Layout No.';
            NotBlank = true;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            NotBlank = true;
        }
        field(3; "Table No."; Integer)
        {
            Caption = 'Table No.';
        }
        field(4; "Table Name"; Text[30])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Table), "Object ID" = field("Table No.")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; Level; Integer)
        {
            Caption = 'Level';
            Editable = false;
            MinValue = 0;
        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(7; "Section Type"; Option)
        {
            Caption = 'Section Type';
            OptionCaption = 'Header,Line,Footer';
            OptionMembers = Header,Line,Footer;
        }
        field(8; Pages; Option)
        {
            Caption = 'Pages';
            OptionCaption = 'All,First,Last,Not First,Not Last';
            OptionMembers = All,First,Last,"Not First","Not Last";

            trigger OnValidate()
            var
                DocumentLayout: Record "DC - Document Layout";
            begin
                DocumentLayout.Get("Layout No.");
                DocumentLayout.CalcFields("Flow Layout");
                if DocumentLayout."Flow Layout" then
                    case "Section Type" of
                        "Section Type"::Header:
                            if not (Pages in [Pages::All, Pages::First]) then
                                DocumentLayout.TestField("Flow Layout", false);
                        "Section Type"::Line:
                            DocumentLayout.TestField("Flow Layout", false);
                        "Section Type"::Footer:
                            DocumentLayout.TestField("Flow Layout", false);
                    end;
            end;
        }
        field(9; "Parent Line No."; Integer)
        {
            Caption = 'Parent Line No.';
        }
        field(10; "Key No."; Integer)
        {
            Caption = 'Key No.';
        }
        field(11; "Key"; Text[250])
        {
            CalcFormula = lookup(Key.Key where(TableNo = field("Table No."),
                                                "No." = field("Key No.")));
            Caption = 'Key';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Descending"; Boolean)
        {
            Caption = 'Absteigend';
        }
        field(13; "Phantom Layout No."; Code[10])
        {
            Caption = 'Phantom Layout No.';
        }
        field(14; "Page Break"; Option)
        {
            Caption = 'Page Break';
            OptionCaption = ' ,Between Records,,After Block,After Each Record';
            OptionMembers = " ","Between Records",,"After Block","After Each Record";

            trigger OnValidate()
            begin
                if "Page Break" <> "Page Break"::" " then begin
                    TestField("Section Type", "Section Type"::Line);
                    TestField("Phantom Layout No.", '');
                end;
            end;
        }
        field(50; "No. of Filters"; Integer)
        {
            CalcFormula = count("DC - Document Layout Filter" where("Layout No." = field("Layout No."),
                                                                     "Layout Line No." = field("Line No."),
                                                                     "Layout Criteria Line No." = const(0),
                                                                     "Layout Field Line No." = const(0),
                                                                     "Layout Variable Line No." = const(0),
                                                                     "Layout Codeunit Line No." = const(0)));
            Caption = 'No. of Filters';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "No. of Criteria"; Integer)
        {
            CalcFormula = count("DC - Document Layout Criterion" where("Layout No." = field("Layout No."),
                                                                        "Layout Line No." = field("Line No."),
                                                                        "Layout Field Line No." = const(0),
                                                                        "Layout Variable Line No." = const(0),
                                                                        "Layout Codeunit Line No." = const(0)));
            Caption = 'No. of Criteria';
            Editable = false;
            FieldClass = FlowField;
        }
        field(52; "No. of Codeunits"; Integer)
        {
            CalcFormula = count("DC - Document Layout Codeunit" where("Layout No." = field("Layout No."),
                                                                       "Layout Line No." = field("Line No.")));
            Caption = 'No. of Codeunits';
            Editable = false;
            FieldClass = FlowField;
        }
        field(53; "No. of Variables"; Integer)
        {
            CalcFormula = count("DC - Document Layout Variable" where("Layout No." = field("Layout No."),
                                                                       "Layout Line No." = field("Line No.")));
            Caption = 'No. of Variables';
            Editable = false;
            FieldClass = FlowField;
        }
        field(54; "No. of Fields"; Integer)
        {
            CalcFormula = count("DC - Document Layout Field" where("Layout No." = field("Layout No."),
                                                                    "Layout Line No." = field("Line No.")));
            Caption = 'No. of Fields';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Layout No.", "Line No.")
        {
            Clustered = true;
        }
    }
    procedure ShowFields()
    begin
    end;

    procedure ShowFilters()
    begin
    end;

    procedure ShowCriteria()
    begin
    end;

    procedure ShowVariables()
    begin
    end;

    procedure ShowCodeunits()
    begin
    end;

    procedure MoveRight()
    begin
    end;

    procedure MoveLeft()
    begin
    end;

    procedure CopyLayoutLine()
    begin
    end;
}
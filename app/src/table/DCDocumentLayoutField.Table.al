table 12032003 "DC - Document Layout Field"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland
    // cc|document configurator (CCDC)
    // cc|formatted documents (CCFD)

    Caption = 'Document Layout Field';

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
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            NotBlank = true;
        }
        field(4; Line; Integer)
        {
            Caption = 'Line';

            trigger OnValidate()
            var
                DocumentLayoutField: Record "DC - Document Layout Field";
            begin
                if (Line <> xRec.Line) and (CurrFieldNo = FieldNo(Line)) then
                    if "Group Code" <> '' then begin
                        DocumentLayoutField.SetRange("Layout No.", "Layout No.");
                        DocumentLayoutField.SetRange("Group Code", "Group Code");
                        if DocumentLayoutField.FindSet(true, false) then
                            repeat
                                if DocumentLayoutField.GetPosition() <> GetPosition() then begin
                                    DocumentLayoutField.Validate(Line, DocumentLayoutField.Line - (xRec.Line - Line));
                                    DocumentLayoutField.Modify();
                                end;
                            until DocumentLayoutField.Next() = 0;
                    end;
            end;
        }
        field(5; "Indentation (pt)"; Integer)
        {
            Caption = 'Indentation (pt)';
            MinValue = 0;

            trigger OnValidate()
            var
                DocumentLayoutField: Record "DC - Document Layout Field";
            begin
                if ("Indentation (pt)" <> xRec."Indentation (pt)") and (CurrFieldNo = FieldNo("Indentation (pt)")) then
                    if "Group Code" <> '' then begin
                        DocumentLayoutField.SetRange("Layout No.", "Layout No.");
                        DocumentLayoutField.SetRange("Group Code", "Group Code");
                        if DocumentLayoutField.FindSet(true, false) then
                            repeat
                                if DocumentLayoutField.GetPosition() <> GetPosition() then begin
                                    DocumentLayoutField.Validate("Indentation (pt)", DocumentLayoutField."Indentation (pt)" -
                                    (xRec."Indentation (pt)" - "Indentation (pt)"));
                                    DocumentLayoutField.Modify();
                                end;
                            until DocumentLayoutField.Next() = 0;
                    end;
            end;
        }
        field(6; "Field Width (pt)"; Integer)
        {
            Caption = 'Field Width (pt)';
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Field Width (pt)" = 0 then
                    TestField(Alignment, Alignment::Left);
            end;
        }
        field(7; Type; Option)
        {
            Caption = 'Type';
            Description = 'CCFD';
            OptionCaption = 'Value,Caption,Text,Document Text,System,,,,,Subreport (via Formatted Documents)';
            OptionMembers = Value,Caption,Text,"Document Text",System,,,,,"Subreport (FD)";

            trigger OnValidate()
            begin
                if Type = Type::Value then begin
                    Text := '';
                    "Document Text Code" := '';
                    "System Value" := "System Value"::" ";
                end;

                if Type = Type::Caption then begin
                    Text := '';
                    "Document Text Code" := '';
                    "System Value" := "System Value"::" ";
                end;

                if Type = Type::Text then begin
                    "Table No." := 0;
                    "Field No." := 0;
                    CalcFields("Table Name");
                    CalcFields("Field Name");
                    "Document Text Code" := '';
                    "System Value" := "System Value"::" ";
                end;

                if Type = Type::"Document Text" then begin
                    "Table No." := 0;
                    "Field No." := 0;
                    CalcFields("Table Name");
                    CalcFields("Field Name");
                    Text := '';
                    "System Value" := "System Value"::" ";
                end;

                if Type = Type::System then begin
                    "Table No." := 0;
                    "Field No." := 0;
                    CalcFields("Table Name");
                    CalcFields("Field Name");
                    Text := '';
                    "Document Text Code" := '';
                end;
            end;
        }
        field(8; "Table No."; Integer)
        {
            Caption = 'Table No.';
        }
        field(9; "Table Name"; Text[30])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Table),
                                                                        "Object ID" = field("Table No.")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Field No."; Integer)
        {
            Caption = 'Field No.';
        }
        field(11; "Field Name"; Text[30])
        {
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Table No."),
                                                        "No." = field("Field No.")));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Last Record"; Boolean)
        {
            Caption = 'Last Record';
        }
        field(14; "Blank Zero"; Boolean)
        {
            Caption = 'Blank Zero';
        }
        field(15; Rounding; Decimal)
        {
            Caption = 'Rounding';
        }
        field(16; "Format String"; Text[100])
        {
            Caption = 'Format String';
        }
        field(17; Alignment; Option)
        {
            Caption = 'Alignment';
            OptionCaption = 'Left,Center,Right';
            OptionMembers = Left,Center,Right;

            trigger OnValidate()
            begin
                if Alignment <> Alignment::Left then
                    TestField("Field Width (pt)");
            end;
        }
        field(18; "Document Text Code"; Code[20])
        {
            Caption = 'Document Text Code';
            TableRelation = "DC - Document Text".Code;

            trigger OnValidate()
            var
                DocumentText: Record "DC - Document Text";
            begin
                if "Document Text Code" <> '' then
                    TestField(Type, Type::"Document Text");

                if Description = '' then
                    if DocumentText.Get("Document Text Code") then
                        Description := CopyStr(DocumentText.Text, 1, 50);
            end;
        }
        field(19; Text; Text[250])
        {
            Caption = 'Text';

            trigger OnValidate()
            begin
                if Text <> '' then
                    TestField(Type, Type::Text);
            end;
        }
        field(20; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(21; "Allow Line Break"; Boolean)
        {
            Caption = 'Allow Line Break';

            trigger OnValidate()
            begin
                if "Allow Line Break" then
                    TestField("Field Width (pt)");
            end;
        }
        field(22; "Skip if Blank"; Boolean)
        {
            Caption = 'Skip if Blank';
        }
        field(23; "System Value"; Option)
        {
            Caption = 'System Value';
            OptionCaption = ' ,User ID,Today,Workdate,User Language,Time,Company Name';
            OptionMembers = " ","User ID",Today,Workdate,"User Language",Time,"Company Name";

            trigger OnValidate()
            begin
                if Description = '' then
                    Description := Format("System Value");
            end;
        }
        field(24; "Group Code"; Code[20])
        {
            Caption = 'Group Code';
        }
        field(25; Uppercase; Boolean)
        {
            Caption = 'Uppercase';
        }
        field(30; "Font Style"; Option)
        {
            Caption = 'Font Style';
            OptionCaption = 'Normal,Italic';
            OptionMembers = Normal,Italic;
        }
        field(31; "Font Family"; Text[30])
        {
            Caption = 'Font Family';
        }
        field(32; "Font Size"; Integer)
        {
            Caption = 'Font Size';
        }
        field(33; "Font Weight"; Option)
        {
            Caption = 'Font Weight';
            OptionCaption = 'Normal,Lighter,Thin,Extra Light,Light,Medium,Semi-bold,Bold,Extra Bold,Heavy,Bolder';
            OptionMembers = Normal,Lighter,Thin,"Extra Light",Light,Medium,"Semi-bold",Bold,"Extra Bold",Heavy,Bolder;
        }
        field(34; "Fore Color"; Text[30])
        {
            Caption = 'Fore Color';
        }
        field(35; "Text Decoration"; Option)
        {
            Caption = 'Text Decoration';
            OptionCaption = 'None,Underline,Overline,LineThrough';
            OptionMembers = "None",Underline,Overline,LineThrough;
        }
        field(36; "Vertical Alignment"; Option)
        {
            Caption = 'Vertical Alignment';
            OptionCaption = 'Top,Middle';
            OptionMembers = Top,Middle;
        }
        field(50; "No. of Filters"; Integer)
        {
            CalcFormula = count("DC - Document Layout Filter" where("Layout No." = field("Layout No."),
                                                                     "Layout Line No." = field("Layout Line No."),
                                                                     "Layout Criteria Line No." = const(0),
                                                                     "Layout Field Line No." = field("Line No."),
                                                                     "Layout Variable Line No." = const(0),
                                                                     "Layout Codeunit Line No." = const(0)));
            Caption = 'No. of Filters';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "No. of Criteria"; Integer)
        {
            CalcFormula = count("DC - Document Layout Criterion" where("Layout No." = field("Layout No."),
                                                                        "Layout Line No." = field("Layout Line No."),
                                                                        "Layout Field Line No." = field("Line No."),
                                                                        "Layout Variable Line No." = const(0),
                                                                        "Layout Codeunit Line No." = const(0)));
            Caption = 'No. of Criteria';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "BLOB Field Usage"; Option)
        {
            Caption = 'BLOB Field Usage';
            Description = 'CCFD';
            OptionCaption = 'Ignore,Image,,,,,Formatted Documents';
            OptionMembers = Ignore,Image,,,,,"Formatted Documents";
        }
        field(65; "Carry Over"; Option)
        {
            Caption = 'Carry Over';
            OptionCaption = ' ,Create,,,,,Stop';
            OptionMembers = " ",Create,,,,,Stop;
        }
        field(5305932; "Subreport No."; Integer)
        {
            Caption = 'Subreport No.';
            Description = 'CCFD';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Report));
        }
    }

    keys
    {
        key(Key1; "Layout No.", "Layout Line No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Layout No.", "Layout Line No.", Line, "Indentation (pt)")
        {
        }
    }

    var
        TextCarryOverCreateNumeric: Label 'may be set to %1 for numerical fields only';
        TextCarryOverCreateOnce: Label 'You can set %1 only once per layout to %2. %2 has been already set in line %3, field %4.';


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


    procedure SetFieldWidth(ColumnMargin: Integer)
    var
        DocumentLayout: Record "DC - Document Layout";
        DocumentLayoutField: Record "DC - Document Layout Field";
    begin
        DocumentLayout.Get("Layout No.");
        if DocumentLayout.Status = DocumentLayout.Status::Certified then
            DocumentLayout.FieldError(Status);

        DocumentLayoutField.SetCurrentKey("Layout No.", "Layout Line No.", Line, "Indentation (pt)");
        DocumentLayoutField.SetRange("Layout No.", "Layout No.");
        DocumentLayoutField.SetRange("Layout Line No.", "Layout Line No.");
        DocumentLayoutField.SetRange(Line, Line);
        DocumentLayoutField.SetFilter("Indentation (pt)", '>%1', "Indentation (pt)");
        if DocumentLayoutField.FindFirst() then
            "Field Width (pt)" := DocumentLayoutField."Indentation (pt)" - "Indentation (pt)" - ColumnMargin;

        if "Field Width (pt)" < 0 then
            "Field Width (pt)" := 0;

        Modify();
    end;


    procedure TestCarryOver()
    begin
    end;
}
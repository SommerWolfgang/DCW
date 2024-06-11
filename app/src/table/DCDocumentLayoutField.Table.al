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
            TableRelation = "DC - Document Layout Line"."Line No." WHERE("Layout No." = FIELD("Layout No."));
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
                                if DocumentLayoutField.GetPosition <> GetPosition then begin
                                    DocumentLayoutField.Validate(Line, DocumentLayoutField.Line - (xRec.Line - Line));
                                    DocumentLayoutField.Modify;
                                end;
                            until DocumentLayoutField.Next = 0;
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
                                if DocumentLayoutField.GetPosition <> GetPosition then begin
                                    DocumentLayoutField.Validate("Indentation (pt)", DocumentLayoutField."Indentation (pt)" -
                                    (xRec."Indentation (pt)" - "Indentation (pt)"));
                                    DocumentLayoutField.Modify;
                                end;
                            until DocumentLayoutField.Next = 0;
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
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));

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
                if "Table No." <> 0 then
                    if (Type = Type::Text) or (Type = Type::"Document Text") or (Type = Type::System) then
                        FieldError(Type);

                if "Table No." = 0 then
                    Validate("Field No.", 0);

                CalcFields("Table Name");
            end;
        }
        field(9; "Table Name"; Text[30])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Table),
                                                                        "Object ID" = FIELD("Table No.")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Field No."; Integer)
        {
            Caption = 'Field No.';
            TableRelation = Field."No." WHERE(TableNo = FIELD("Table No."));

            trigger OnLookup()
            var
                ConfiguratorDocMng: Codeunit "DC - Management";
                FieldID: Integer;
            begin
                TestField("Table No.");

                FieldID := ConfiguratorDocMng.LookupField("Table No.");

                if FieldID <> 0 then
                    Validate("Field No.", FieldID);
            end;

            trigger OnValidate()
            begin
                if "Field No." <> 0 then
                    if (Type = Type::Text) or (Type = Type::"Document Text") or (Type = Type::System) then
                        FieldError(Type);

                CalcFields("Field Name");

                if Description = '' then
                    Description := "Field Name";
            end;
        }
        field(11; "Field Name"; Text[30])
        {
            CalcFormula = Lookup(Field.FieldName WHERE(TableNo = FIELD("Table No."),
                                                        "No." = FIELD("Field No.")));
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

            trigger OnLookup()
            var
                DocumentConfigMgt: Codeunit "DC - Management";
            begin
                DocumentConfigMgt.SelectFont("Font Family", "Font Size");
            end;
        }
        field(32; "Font Size"; Integer)
        {
            Caption = 'Font Size';

            trigger OnLookup()
            var
                DocumentConfigMgt: Codeunit "DC - Management";
            begin
                DocumentConfigMgt.SelectFont("Font Family", "Font Size");
            end;
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

            trigger OnLookup()
            var
                DocumentConfigMgt: Codeunit "DC - Management";
            begin
                DocumentConfigMgt.SelectColor("Fore Color");
            end;
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
            CalcFormula = Count("DC - Document Layout Filter" WHERE("Layout No." = FIELD("Layout No."),
                                                                     "Layout Line No." = FIELD("Layout Line No."),
                                                                     "Layout Criteria Line No." = CONST(0),
                                                                     "Layout Field Line No." = FIELD("Line No."),
                                                                     "Layout Variable Line No." = CONST(0),
                                                                     "Layout Codeunit Line No." = CONST(0)));
            Caption = 'No. of Filters';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "No. of Criteria"; Integer)
        {
            CalcFormula = Count("DC - Document Layout Criterion" WHERE("Layout No." = FIELD("Layout No."),
                                                                        "Layout Line No." = FIELD("Layout Line No."),
                                                                        "Layout Field Line No." = FIELD("Line No."),
                                                                        "Layout Variable Line No." = CONST(0),
                                                                        "Layout Codeunit Line No." = CONST(0)));
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
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Report));
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
        DocumentLayoutFilter.SetRange("Layout Field Line No.", "Line No.");
        DocumentLayoutFilter.SetRange("Layout Variable Line No.", 0);
        DocumentLayoutFilter.SetRange("Layout Codeunit Line No.", 0);
        DocumentLayoutFilter.DeleteAll(true);

        DocumentLayoutCriteria.SetRange("Layout No.", "Layout No.");
        DocumentLayoutCriteria.SetRange("Layout Line No.", "Layout Line No.");
        DocumentLayoutCriteria.SetRange("Layout Field Line No.", "Line No.");
        DocumentLayoutCriteria.SetRange("Layout Variable Line No.", 0);
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
        TestCarryOver;
        DocConfMng.OnModifyCode("Layout No.");
    end;

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
        if DocumentLayoutField.FindFirst then
            "Field Width (pt)" := DocumentLayoutField."Indentation (pt)" - "Indentation (pt)" - ColumnMargin;

        if "Field Width (pt)" < 0 then
            "Field Width (pt)" := 0;

        Modify;
    end;


    procedure TestCarryOver()
    var
        DocumentLayoutField: Record "DC - Document Layout Field";
        DocumentLayoutLine: Record "DC - Document Layout Line";
        DocumentLayoutVariable: Record "DC - Document Layout Variable";
        DCMgt: Codeunit "DC - Management";
        IsNormalText: Boolean;
        IsNumeric: Boolean;
        Dec: Decimal;
        i: Integer;
        Text2: Text;
        VariableName: Text;
    begin
        if "Carry Over" <> "Carry Over"::" " then begin
            // Populate field only on lines with Section Type = Line
            DocumentLayoutLine.Get("Layout No.", "Layout Line No.");
            DocumentLayoutLine.TestField("Section Type", DocumentLayoutLine."Section Type"::Line);

            case "Carry Over" of
                "Carry Over"::Create:
                    begin
                        // Create is allowed maximum once per layout
                        DocumentLayoutField.SetRange("Layout No.", "Layout No.");
                        DocumentLayoutField.SetRange("Carry Over", DocumentLayoutField."Carry Over"::Create);
                        if DocumentLayoutField.FindSet then begin
                            repeat
                                if not
                                  ((DocumentLayoutField."Layout Line No." = "Layout Line No.") and
                                  (DocumentLayoutField."Line No." = "Line No."))
                                then begin
                                    DocumentLayoutLine.Get(DocumentLayoutField."Layout No.", DocumentLayoutField."Layout Line No.");
                                    Error(
                                      TextCarryOverCreateOnce,
                                      FieldCaption("Carry Over"),
                                      Format("Carry Over"::Create),
                                      DocumentLayoutLine.Description,
                                      DocumentLayoutField.Description);
                                end;
                            until DocumentLayoutField.Next = 0;
                        end;

                        // Allowed only for nummerical values
                        case Type of
                            Type::Value:
                                begin
                                    TestField("Table No.");
                                    TestField("Field No.");
                                    IsNumeric := DCMgt.CheckIfTableFieldIsNumeric("Table No.", "Field No.")
                                end;
                            Type::Text:
                                begin
                                    TestField(Text);
                                    IsNumeric := true;
                                    IsNormalText := true;
                                    repeat
                                        i += 1;
                                        case Text[i] of
                                            '[':
                                                begin
                                                    IsNormalText := false;
                                                    VariableName := '';
                                                end;
                                            ']':
                                                begin
                                                    IsNormalText := true;
                                                    DocumentLayoutVariable.SetRange("Layout No.", "Layout No.");
                                                    DocumentLayoutVariable.SetFilter("Layout Line No.", '<=%1', "Layout Line No.");
                                                    DocumentLayoutVariable.SetRange(Variable, VariableName);
                                                    DocumentLayoutVariable.FindLast;
                                                    IsNumeric := DocumentLayoutVariable.IsNumeric;
                                                    if IsNumeric then begin
                                                        // Replace variable placeholder in text with formatted (dummy) number
                                                        Text2 += '100';
                                                    end;
                                                end;
                                            else begin
                                                if IsNormalText then begin
                                                    Text2 += CopyStr(Text, i, 1);
                                                end else begin
                                                    VariableName += CopyStr(Text, i, 1);
                                                    if i = MaxStrLen(Text) then begin
                                                        Text2 += '[' + VariableName;
                                                    end;
                                                end;
                                            end;
                                        end;
                                    until (i = MaxStrLen(Text)) or (not IsNumeric);
                                    if IsNumeric then
                                        IsNumeric := Evaluate(Dec, Text2);
                                end;
                            else begin
                                IsNumeric := false;
                            end;
                        end;
                        if not IsNumeric then
                            FieldError("Carry Over", StrSubstNo(TextCarryOverCreateNumeric, Format("Carry Over"::Create)));
                    end;

                "Carry Over"::Stop:
                    begin
                    end;
            end;
        end;
    end;
}


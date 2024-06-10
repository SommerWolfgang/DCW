table 12032002 "DC - Document Layout Line"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland
    // cc|document configurator (CCDC)

    Caption = 'Document Layout Line';

    fields
    {
        field(1; "Layout No."; Code[10])
        {
            Caption = 'Layout No.';
            NotBlank = true;
            TableRelation = "DC - Document Layout"."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            NotBlank = true;
        }
        field(3; "Table No."; Integer)
        {
            Caption = 'Table No.';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));

            trigger OnLookup()
            var
                DocConfMng: Codeunit "DC - Management";
                ObjectID: Integer;
            begin
                ObjectID := DocConfMng.LookupObject('T');

                if ObjectID <> 0 then
                    Validate("Table No.", ObjectID);
            end;

            trigger OnValidate()
            begin
                CalcFields("Table Name");

                if "Table No." <> xRec."Table No." then
                    Validate("Key No.", 1);
            end;
        }
        field(4; "Table Name"; Text[30])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Table),
                                                                        "Object ID" = FIELD("Table No.")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; Level; Integer)
        {
            Caption = 'Level';
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            var
                ParentLine: Record "DC - Document Layout Line";
            begin
                if Level <> 0 then begin
                    ParentLine.SetRange("Layout No.", "Layout No.");
                    ParentLine.SetFilter("Line No.", '<%1', "Line No.");
                    ParentLine.SetRange(Level, Level - 1);
                    ParentLine.FindLast;
                    "Parent Line No." := ParentLine."Line No.";
                end else begin
                    "Parent Line No." := 0;
                end;
            end;
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

            trigger OnValidate()
            begin
                if "Section Type" <> "Section Type"::Line then begin
                    TestField("Page Break", "Page Break"::" ");
                end;
            end;
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

            trigger OnLookup()
            var
                DocConfMng: Codeunit "DC - Management";
                KeyNo: Integer;
            begin
                KeyNo := DocConfMng.LookupKey("Table No.");

                if KeyNo <> 0 then
                    Validate("Key No.", KeyNo);
            end;

            trigger OnValidate()
            begin
                CalcFields(Key);
            end;
        }
        field(11; "Key"; Text[250])
        {
            CalcFormula = Lookup(Key.Key WHERE(TableNo = FIELD("Table No."),
                                                "No." = FIELD("Key No.")));
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
            TableRelation = "DC - Document Layout"."No." WHERE("Top DataItem Table No." = FIELD("Table No."),
                                                                "Phantom Layout" = CONST(true));

            trigger OnValidate()
            var
                DocumentLayout: Record "DC - Document Layout";
            begin
                DocumentLayout.Get("Layout No.");
                DocumentLayout.TestField("Phantom Layout", false);

                if "Phantom Layout No." <> '' then begin
                    TestField("Page Break", "Page Break"::" ");
                end;
            end;
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
            CalcFormula = Count("DC - Document Layout Filter" WHERE("Layout No." = FIELD("Layout No."),
                                                                     "Layout Line No." = FIELD("Line No."),
                                                                     "Layout Criteria Line No." = CONST(0),
                                                                     "Layout Field Line No." = CONST(0),
                                                                     "Layout Variable Line No." = CONST(0),
                                                                     "Layout Codeunit Line No." = CONST(0)));
            Caption = 'No. of Filters';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "No. of Criteria"; Integer)
        {
            CalcFormula = Count("DC - Document Layout Criterion" WHERE("Layout No." = FIELD("Layout No."),
                                                                        "Layout Line No." = FIELD("Line No."),
                                                                        "Layout Field Line No." = CONST(0),
                                                                        "Layout Variable Line No." = CONST(0),
                                                                        "Layout Codeunit Line No." = CONST(0)));
            Caption = 'No. of Criteria';
            Editable = false;
            FieldClass = FlowField;
        }
        field(52; "No. of Codeunits"; Integer)
        {
            CalcFormula = Count("DC - Document Layout Codeunit" WHERE("Layout No." = FIELD("Layout No."),
                                                                       "Layout Line No." = FIELD("Line No.")));
            Caption = 'No. of Codeunits';
            Editable = false;
            FieldClass = FlowField;
        }
        field(53; "No. of Variables"; Integer)
        {
            CalcFormula = Count("DC - Document Layout Variable" WHERE("Layout No." = FIELD("Layout No."),
                                                                       "Layout Line No." = FIELD("Line No.")));
            Caption = 'No. of Variables';
            Editable = false;
            FieldClass = FlowField;
        }
        field(54; "No. of Fields"; Integer)
        {
            CalcFormula = Count("DC - Document Layout Field" WHERE("Layout No." = FIELD("Layout No."),
                                                                    "Layout Line No." = FIELD("Line No.")));
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

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        DocumentLayoutCodeunit: Record "DC - Document Layout Codeunit";
        DocumentLayoutCriteria: Record "DC - Document Layout Criterion";
        DocumentLayoutField: Record "DC - Document Layout Field";
        DocumentLayoutFilter: Record "DC - Document Layout Filter";
        DocumentLayoutVariable: Record "DC - Document Layout Variable";
        DocConfMng: Codeunit "DC - Management";
    begin
        DocConfMng.OnDeleteCode("Layout No.");

        DocumentLayoutField.SetRange("Layout No.", "Layout No.");
        DocumentLayoutField.SetRange("Layout Line No.", "Line No.");
        DocumentLayoutField.DeleteAll(true);

        DocumentLayoutFilter.SetRange("Layout No.", "Layout No.");
        DocumentLayoutFilter.SetRange("Layout Line No.", "Line No.");
        DocumentLayoutFilter.DeleteAll(true);

        DocumentLayoutCriteria.SetRange("Layout No.", "Layout No.");
        DocumentLayoutCriteria.SetRange("Layout Line No.", "Line No.");
        DocumentLayoutCriteria.DeleteAll(true);

        DocumentLayoutVariable.SetRange("Layout No.", "Layout No.");
        DocumentLayoutVariable.SetRange("Layout Line No.", "Line No.");
        DocumentLayoutVariable.DeleteAll(true);

        DocumentLayoutCodeunit.SetRange("Layout No.", "Layout No.");
        DocumentLayoutCodeunit.SetRange("Layout Line No.", "Line No.");
        DocumentLayoutCodeunit.DeleteAll(true);
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

    var
        Text001: Label 'Copy a Document Layout Section will replace existsing Filters, Variables, Codeunits, Conditions and Fields.\\Continue?';
        Text002: Label 'You are about to copy a Document Layout Section that is based on another table.\The system will replace all occurrence of table %1 with table %2.\After this you need to go through and confirm the setup.\\Continue?';


    procedure ShowFields()
    var
        DocumentLayoutField: Record "DC - Document Layout Field";
        DocumentLayoutFields: Page "DC - Document Layout Fields";
    begin
        DocumentLayoutField.SetRange("Layout No.", "Layout No.");
        DocumentLayoutField.SetRange("Layout Line No.", "Line No.");

        DocumentLayoutFields.SetTableView(DocumentLayoutField);
        DocumentLayoutFields.RunModal;
    end;


    procedure ShowFilters()
    var
        DocumentLayoutFilter: Record "DC - Document Layout Filter";
        DocumentLayoutFilters: Page "DC - Document Layout Filters";
    begin
        DocumentLayoutFilter.SetRange("Layout No.", "Layout No.");
        DocumentLayoutFilter.SetRange("Layout Line No.", "Line No.");
        DocumentLayoutFilter.SetRange("Layout Field Line No.", 0);
        DocumentLayoutFilter.SetRange("Layout Criteria Line No.", 0);
        DocumentLayoutFilter.SetRange("Layout Variable Line No.", 0);
        DocumentLayoutFilter.SetRange("Layout Codeunit Line No.", 0);

        DocumentLayoutFilters.SetTableView(DocumentLayoutFilter);
        DocumentLayoutFilters.RunModal;
    end;


    procedure ShowCriteria()
    var
        DocumentLayoutCriterion: Record "DC - Document Layout Criterion";
        DocumentLayoutCriteria: Page "DC - Document Layout Criteria";
    begin
        DocumentLayoutCriterion.SetRange("Layout No.", "Layout No.");
        DocumentLayoutCriterion.SetRange("Layout Line No.", "Line No.");
        DocumentLayoutCriterion.SetRange("Layout Field Line No.", 0);
        DocumentLayoutCriterion.SetRange("Layout Variable Line No.", 0);
        DocumentLayoutCriterion.SetRange("Layout Codeunit Line No.", 0);

        DocumentLayoutCriteria.SetTableView(DocumentLayoutCriterion);
        DocumentLayoutCriteria.RunModal;
    end;


    procedure ShowVariables()
    var
        DocumentLayoutVariable: Record "DC - Document Layout Variable";
        DocumentLayoutVariables: Page "DC - Document Layout Variables";
    begin
        DocumentLayoutVariable.SetRange("Layout No.", "Layout No.");
        DocumentLayoutVariable.SetRange("Layout Line No.", "Line No.");

        DocumentLayoutVariables.SetTableView(DocumentLayoutVariable);
        DocumentLayoutVariables.RunModal;
    end;


    procedure ShowCodeunits()
    var
        DocumentLayoutCodeunit: Record "DC - Document Layout Codeunit";
        DocumentLayoutCodeunits: Page "DC - Document Layout Codeunits";
    begin
        DocumentLayoutCodeunit.SetRange("Layout No.", "Layout No.");
        DocumentLayoutCodeunit.SetRange("Layout Line No.", "Line No.");

        DocumentLayoutCodeunits.SetTableView(DocumentLayoutCodeunit);
        DocumentLayoutCodeunits.RunModal;
    end;


    procedure MoveRight()
    begin
        Validate(Level, Level + 1);
    end;


    procedure MoveLeft()
    begin
        if Level > 0 then
            Validate(Level, Level - 1);
    end;


    procedure CopyLayoutLine()
    var
        CopyFromDocumentLayoutCodeunit: Record "DC - Document Layout Codeunit";
        DocumentLayoutCodeunit: Record "DC - Document Layout Codeunit";
        CopyFromDocumentLayoutCriteria: Record "DC - Document Layout Criterion";
        DocumentLayoutCriteria: Record "DC - Document Layout Criterion";
        CopyFromDocumentLayoutField: Record "DC - Document Layout Field";
        DocumentLayoutField: Record "DC - Document Layout Field";
        CopyFromDocumentLayoutFilter: Record "DC - Document Layout Filter";
        DocumentLayoutFilter: Record "DC - Document Layout Filter";
        CopyFromDocumentLayoutLine: Record "DC - Document Layout Line";
        DocumentLayoutLine: Record "DC - Document Layout Line";
        CopyFromDocumentLayoutVariable: Record "DC - Document Layout Variable";
        DocumentLayoutVariable: Record "DC - Document Layout Variable";
        "Field": Record "Field";
        DocumentLayoutLineList: Page "DC - Document Layout Line List";
        InsertRec: Boolean;
    begin
        Rec.Find;
        TestField("Table No.");

        DocumentLayoutLineList.LookupMode(true);
        DocumentLayoutLineList.SetTableView(CopyFromDocumentLayoutLine);
        if DocumentLayoutLineList.RunModal <> ACTION::LookupOK then
            exit;
        DocumentLayoutLineList.GetRecord(CopyFromDocumentLayoutLine);

        if not Confirm(Text001, false) then
            exit;

        CopyFromDocumentLayoutLine.CalcFields("Table Name");
        CalcFields("Table Name");

        if "Table No." <> CopyFromDocumentLayoutLine."Table No." then
            if not Confirm(StrSubstNo(Text002, Format(CopyFromDocumentLayoutLine."Table No.") + ' - ' +
                           CopyFromDocumentLayoutLine."Table Name", Format("Table No.") + ' - ' + "Table Name"), false) then
                exit;

        DocumentLayoutField.SetRange("Layout No.", "Layout No.");
        DocumentLayoutField.SetRange("Layout Line No.", "Line No.");
        DocumentLayoutField.DeleteAll(true);

        DocumentLayoutFilter.SetRange("Layout No.", "Layout No.");
        DocumentLayoutFilter.SetRange("Layout Line No.", "Line No.");
        DocumentLayoutFilter.DeleteAll(true);

        DocumentLayoutCriteria.SetRange("Layout No.", "Layout No.");
        DocumentLayoutCriteria.SetRange("Layout Line No.", "Line No.");
        DocumentLayoutCriteria.DeleteAll(true);

        DocumentLayoutCodeunit.SetRange("Layout No.", "Layout No.");
        DocumentLayoutCodeunit.SetRange("Layout Line No.", "Line No.");
        DocumentLayoutCodeunit.DeleteAll(true);

        DocumentLayoutVariable.SetRange("Layout No.", "Layout No.");
        DocumentLayoutVariable.SetRange("Layout Line No.", "Line No.");
        DocumentLayoutVariable.DeleteAll(true);

        CopyFromDocumentLayoutField.SetRange("Layout No.", CopyFromDocumentLayoutLine."Layout No.");
        CopyFromDocumentLayoutField.SetRange("Layout Line No.", CopyFromDocumentLayoutLine."Line No.");
        if CopyFromDocumentLayoutField.FindSet(false, false) then
            repeat
                DocumentLayoutField.Init;
                DocumentLayoutField.TransferFields(CopyFromDocumentLayoutField);
                if CopyFromDocumentLayoutField."Table No." = CopyFromDocumentLayoutLine."Table No." then
                    DocumentLayoutField."Table No." := "Table No.";
                DocumentLayoutField."Layout No." := "Layout No.";
                DocumentLayoutField."Layout Line No." := "Line No.";
                InsertRec := true;
                if DocumentLayoutField."Field No." <> 0 then
                    if not Field.Get(DocumentLayoutField."Table No.", DocumentLayoutField."Field No.") then
                        InsertRec := false;
                if InsertRec then
                    DocumentLayoutField.Insert;
            until CopyFromDocumentLayoutField.Next = 0;

        CopyFromDocumentLayoutCriteria.SetRange("Layout No.", CopyFromDocumentLayoutLine."Layout No.");
        CopyFromDocumentLayoutCriteria.SetRange("Layout Line No.", CopyFromDocumentLayoutLine."Line No.");
        if CopyFromDocumentLayoutCriteria.FindSet(false, false) then
            repeat
                DocumentLayoutCriteria.Init;
                DocumentLayoutCriteria.TransferFields(CopyFromDocumentLayoutCriteria);
                if CopyFromDocumentLayoutCriteria."Table No." = CopyFromDocumentLayoutLine."Table No." then
                    DocumentLayoutCriteria."Table No." := "Table No.";
                DocumentLayoutCriteria."Layout No." := "Layout No.";
                DocumentLayoutCriteria."Layout Line No." := "Line No.";
                InsertRec := true;
                if DocumentLayoutCriteria."Sum Field No." <> 0 then
                    if not Field.Get(DocumentLayoutCriteria."Table No.", DocumentLayoutCriteria."Sum Field No.") then
                        InsertRec := false;
                if InsertRec then
                    DocumentLayoutCriteria.Insert;
            until CopyFromDocumentLayoutCriteria.Next = 0;

        CopyFromDocumentLayoutCodeunit.SetRange("Layout No.", CopyFromDocumentLayoutLine."Layout No.");
        CopyFromDocumentLayoutCodeunit.SetRange("Layout Line No.", CopyFromDocumentLayoutLine."Line No.");
        if CopyFromDocumentLayoutCodeunit.FindSet(false, false) then
            repeat
                DocumentLayoutCodeunit.Init;
                DocumentLayoutCodeunit.TransferFields(CopyFromDocumentLayoutCodeunit);
                DocumentLayoutCodeunit."Layout No." := "Layout No.";
                DocumentLayoutCodeunit."Layout Line No." := "Line No.";
                DocumentLayoutCodeunit.Insert;
            until CopyFromDocumentLayoutCodeunit.Next = 0;

        CopyFromDocumentLayoutVariable.SetRange("Layout No.", CopyFromDocumentLayoutLine."Layout No.");
        CopyFromDocumentLayoutVariable.SetRange("Layout Line No.", CopyFromDocumentLayoutLine."Line No.");
        if CopyFromDocumentLayoutVariable.FindSet(false, false) then
            repeat
                DocumentLayoutVariable.Init;
                DocumentLayoutVariable.TransferFields(CopyFromDocumentLayoutVariable);
                if CopyFromDocumentLayoutVariable."Table No." = CopyFromDocumentLayoutLine."Table No." then
                    DocumentLayoutVariable."Table No." := "Table No.";
                DocumentLayoutVariable."Layout No." := "Layout No.";
                DocumentLayoutVariable."Layout Line No." := "Line No.";
                InsertRec := true;
                if DocumentLayoutVariable."Field No." <> 0 then
                    if not Field.Get(DocumentLayoutVariable."Table No.", DocumentLayoutVariable."Field No.") then
                        InsertRec := false;
                if InsertRec then
                    DocumentLayoutVariable.Insert;
            until CopyFromDocumentLayoutVariable.Next = 0;

        CopyFromDocumentLayoutFilter.SetRange("Layout No.", CopyFromDocumentLayoutLine."Layout No.");
        CopyFromDocumentLayoutFilter.SetRange("Layout Line No.", CopyFromDocumentLayoutLine."Line No.");
        if CopyFromDocumentLayoutFilter.FindSet(false, false) then
            repeat
                DocumentLayoutFilter.Init;
                DocumentLayoutFilter.TransferFields(CopyFromDocumentLayoutFilter);
                if CopyFromDocumentLayoutFilter."Filter Table No." = CopyFromDocumentLayoutLine."Table No." then
                    DocumentLayoutFilter."Filter Table No." := "Table No.";
                DocumentLayoutFilter."Layout No." := "Layout No.";
                DocumentLayoutFilter."Layout Line No." := "Line No.";
                DocumentLayoutFilter.InitTableNo;
                InsertRec := true;
                if DocumentLayoutFilter."Field No." <> 0 then
                    if not Field.Get(DocumentLayoutFilter."Table No.", DocumentLayoutFilter."Field No.") then
                        InsertRec := false;
                if DocumentLayoutFilter."Filter Field No." <> 0 then
                    if not Field.Get(DocumentLayoutFilter."Filter Table No.", DocumentLayoutFilter."Filter Field No.") then
                        InsertRec := false;
                if InsertRec then
                    DocumentLayoutFilter.Insert;
            until CopyFromDocumentLayoutFilter.Next = 0;
    end;
}


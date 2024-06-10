table 12032001 "DC - Document Layout"
{
    Caption = 'Document Layout';

    fields
    {
        field(1; "No."; Code[10])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                TestStatus;
            end;
        }
        field(3; "Report No."; Integer)
        {
            Caption = 'Report No.';

            trigger OnLookup()
            var
                DocConfMng: Codeunit "DC - Management";
                ObjectID: Integer;
            begin
                ObjectID := DocConfMng.LookupObject('R');

                if ObjectID <> 0 then
                    Validate("Report No.", ObjectID);
            end;

            trigger OnValidate()
            begin
                CalcFields("Report Name");

                TestStatus;
            end;
        }
        field(4; "Report Name"; Text[30])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Report),
                                                                        "Object ID" = FIELD("Report No.")));
            Caption = 'Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Document Label Code"; Code[20])
        {
            Caption = 'Document Label Code';
            TableRelation = "DC - Document Text".Code;

            trigger OnValidate()
            begin
                TestStatus;
            end;
        }
        field(6; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                TestStatus;
            end;
        }
        field(7; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                TestStatus;
            end;
        }
        field(8; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'New,Certified,Under Development,Closed';
            OptionMembers = New,Certified,"Under Development",Closed;

            trigger OnValidate()
            var
                DocConfMng: Codeunit "DC - Management";
            begin
                DocConfMng.ChangeStatus(xRec, Rec);
            end;
        }
        field(9; "Top DataItem Table No."; Integer)
        {
            Caption = 'Top DataItem Table No.';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));

            trigger OnLookup()
            var
                DocConfMng: Codeunit "DC - Management";
                ObjectID: Integer;
            begin
                ObjectID := DocConfMng.LookupObject('T');

                if ObjectID <> 0 then
                    Validate("Top DataItem Table No.", ObjectID);
            end;

            trigger OnValidate()
            begin
                CalcFields("Top DataItem Table Name");

                TestStatus;
            end;
        }
        field(10; "Top DataItem Table Name"; Text[30])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Table),
                                                                        "Object ID" = FIELD("Top DataItem Table No.")));
            Caption = 'Top DataItem Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Page Height (Lines)"; Integer)
        {
            Caption = 'Page Height (lines)';

            trigger OnValidate()
            begin
                TestStatus;
            end;
        }
        field(12; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
            Editable = false;
        }
        field(13; "Last Modified by User ID"; Code[100])
        {
            Caption = 'Last Modified by User ID';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;

            trigger OnLookup()
            var
                LoginMng: Codeunit "User Management";
                UserID: Code[20];
            begin
                UserID := "Last Modified by User ID";
                LoginMng.LookupUserID(UserID);
            end;
        }
        field(14; "Print from Preview"; Boolean)
        {
            Caption = 'Print from Preview';

            trigger OnValidate()
            begin
                TestStatus;
            end;
        }
        field(15; "Page Width (pt)"; Integer)
        {
            Caption = 'Page Width (pt)';

            trigger OnValidate()
            begin
                TestStatus;
            end;
        }
        field(16; "Phantom Layout"; Boolean)
        {
            Caption = 'Phantom Layout';

            trigger OnValidate()
            begin
                TestStatus;

                if "Phantom Layout" then begin
                    TestField("Report No.", 0);
                    TestField("Document Label Code", '');
                    TestField("Page Height (Lines)", 0);
                    TestField("Page Width (pt)", 0);
                    TestField("Print from Preview", false);
                end;
            end;
        }
        field(17; "Font Family"; Text[30])
        {
            Caption = 'Font Family';

            trigger OnLookup()
            var
                DocumentConfigMng: Codeunit "DC - Management";
            begin
                DocumentConfigMng.SelectFont("Font Family", "Font Size");
                Validate("Font Family");
                Validate("Font Size");
            end;

            trigger OnValidate()
            begin
                TestStatus;
            end;
        }
        field(18; "Font Size"; Integer)
        {
            Caption = 'Font Size';

            trigger OnLookup()
            var
                DocumentConfigMng: Codeunit "DC - Management";
            begin
                DocumentConfigMng.SelectFont("Font Family", "Font Size");
                Validate("Font Family");
                Validate("Font Size");
            end;

            trigger OnValidate()
            begin
                TestStatus;
            end;
        }
        field(19; "Render Report No."; Integer)
        {
            Caption = 'Render Report No.';

            trigger OnLookup()
            var
                DocConfMng: Codeunit "DC - Management";
                ObjectID: Integer;
            begin
                ObjectID := DocConfMng.LookupObject('R');

                if ObjectID <> 0 then
                    Validate("Render Report No.", ObjectID);
            end;

            trigger OnValidate()
            begin
                CalcFields("Render Report Name");

                TestStatus;
            end;
        }
        field(20; "Render Report Name"; Text[30])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Report),
                                                                        "Object ID" = FIELD("Render Report No.")));
            Caption = 'Render Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Quickview Bitmap"; BLOB)
        {
            Caption = 'Quickview Bitmap';
            SubType = Bitmap;
        }
        field(22; "Last Modified Time"; Time)
        {
            Caption = 'Last Modification Time';
            Editable = false;
        }
        field(50; "Flow Layout"; Boolean)
        {
            CalcFormula = Exist(AllObj WHERE("Object Type" = CONST(Report),
                                              "Object ID" = FIELD("Render Report No."),
                                              "Object Name" = FILTER('*Flow*')));
            Caption = 'Rendering Report Uses Flow Layout';
            Editable = false;
            FieldClass = FlowField;
        }
        field(55; "Carry Over Format"; Text[30])
        {
            Caption = 'Carry Over Format';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Report No.")
        {
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
        DocumentLayoutLine: Record "DC - Document Layout Line";
        DocumentLayoutVariable: Record "DC - Document Layout Variable";
    begin
        DocumentLayoutLine.SetRange("Layout No.", "No.");
        DocumentLayoutLine.DeleteAll(true);

        DocumentLayoutField.SetRange("Layout No.", "No.");
        DocumentLayoutField.DeleteAll(true);

        DocumentLayoutFilter.SetRange("Layout No.", "No.");
        DocumentLayoutFilter.DeleteAll(true);

        DocumentLayoutCriteria.SetRange("Layout No.", "No.");
        DocumentLayoutCriteria.DeleteAll(true);

        DocumentLayoutVariable.SetRange("Layout No.", "No.");
        DocumentLayoutVariable.DeleteAll(true);

        DocumentLayoutCodeunit.SetRange("Layout No.", "No.");
        DocumentLayoutCodeunit.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        "Last Modified Date" := Today;
        "Last Modified by User ID" := UserId;

        "Last Modified Time" := Time;
    end;

    trigger OnModify()
    begin
        "Last Modified Date" := Today;
        "Last Modified by User ID" := UserId;

        "Last Modified Time" := Time;
    end;

    var
        Text001: Label 'Copy a Document Layout will replace the existing one. Continue?';
        Text002: Label 'Validating Document Layout!';


    procedure Caption(): Text[120]
    begin
        exit(StrSubstNo('%1 %2', "No.", Description));
    end;


    procedure CopyLayout()
    var
        CopyFromDocumentLayout: Record "DC - Document Layout";
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
        DocumentLayoutList: Page "DC - Document Layout List";
    begin
        Rec.Find;
        TestField("Top DataItem Table No.");

        CopyFromDocumentLayout.SetRange("Top DataItem Table No.", "Top DataItem Table No.");

        DocumentLayoutList.LookupMode(true);
        DocumentLayoutList.SetTableView(CopyFromDocumentLayout);
        if DocumentLayoutList.RunModal <> ACTION::LookupOK then
            exit;
        DocumentLayoutList.GetRecord(CopyFromDocumentLayout);

        if CopyFromDocumentLayout."No." = "No." then
            Error('');

        if not Confirm(Text001, false) then
            exit;

        DocumentLayoutLine.SetRange("Layout No.", "No.");
        DocumentLayoutLine.DeleteAll(true);

        CopyFromDocumentLayoutLine.SetRange("Layout No.", CopyFromDocumentLayout."No.");
        if CopyFromDocumentLayoutLine.FindSet(false, false) then
            repeat
                DocumentLayoutLine.Init;
                DocumentLayoutLine.TransferFields(CopyFromDocumentLayoutLine);
                DocumentLayoutLine."Layout No." := "No.";
                DocumentLayoutLine.Insert;
            until CopyFromDocumentLayoutLine.Next = 0;

        CopyFromDocumentLayoutField.SetRange("Layout No.", CopyFromDocumentLayout."No.");
        if CopyFromDocumentLayoutField.FindSet(false, false) then
            repeat
                DocumentLayoutField.Init;
                DocumentLayoutField.TransferFields(CopyFromDocumentLayoutField);
                DocumentLayoutField."Layout No." := "No.";
                DocumentLayoutField.Insert;
            until CopyFromDocumentLayoutField.Next = 0;

        CopyFromDocumentLayoutFilter.SetRange("Layout No.", CopyFromDocumentLayout."No.");
        if CopyFromDocumentLayoutFilter.FindSet(false, false) then
            repeat
                DocumentLayoutFilter.Init;
                DocumentLayoutFilter.TransferFields(CopyFromDocumentLayoutFilter);
                DocumentLayoutFilter."Layout No." := "No.";
                DocumentLayoutFilter.Insert;
            until CopyFromDocumentLayoutFilter.Next = 0;

        CopyFromDocumentLayoutCriteria.SetRange("Layout No.", CopyFromDocumentLayout."No.");
        if CopyFromDocumentLayoutCriteria.FindSet(false, false) then
            repeat
                DocumentLayoutCriteria.Init;
                DocumentLayoutCriteria.TransferFields(CopyFromDocumentLayoutCriteria);
                DocumentLayoutCriteria."Layout No." := "No.";
                DocumentLayoutCriteria.Insert;
            until CopyFromDocumentLayoutCriteria.Next = 0;

        CopyFromDocumentLayoutCodeunit.SetRange("Layout No.", CopyFromDocumentLayout."No.");
        if CopyFromDocumentLayoutCodeunit.FindSet(false, false) then
            repeat
                DocumentLayoutCodeunit.Init;
                DocumentLayoutCodeunit.TransferFields(CopyFromDocumentLayoutCodeunit);
                DocumentLayoutCodeunit."Layout No." := "No.";
                DocumentLayoutCodeunit.Insert;
            until CopyFromDocumentLayoutCodeunit.Next = 0;

        CopyFromDocumentLayoutVariable.SetRange("Layout No.", CopyFromDocumentLayout."No.");
        if CopyFromDocumentLayoutVariable.FindSet(false, false) then
            repeat
                DocumentLayoutVariable.Init;
                DocumentLayoutVariable.TransferFields(CopyFromDocumentLayoutVariable);
                DocumentLayoutVariable."Layout No." := "No.";
                DocumentLayoutVariable.Insert;
            until CopyFromDocumentLayoutVariable.Next = 0;
    end;


    procedure RunReport(FormattedDocument: Boolean)
    var
        DocumentConfigModuleMgt: Codeunit "DC - Module Management";
        DocumentConfigVariables: Codeunit "DC - Variables";
        DummyVariant: Variant;
    begin
        // CCFD: New parameter FormattedDocument

        if Status <> Status::Certified then begin
            ValidateLayout;
            Commit;
        end;

        DocumentConfigVariables.SetDocumentLayoutNo("No.");
        DocumentConfigVariables.SetTestMode(true);
        // >> CCFD
        if FormattedDocument then
            DocumentConfigModuleMgt.RenderWithFD("Report No.", DummyVariant);
        // << CCFD
        REPORT.RunModal("Report No.");
        DocumentConfigVariables.SetDocumentLayoutNo('');
        DocumentConfigVariables.SetTestMode(false);
        DocumentConfigModuleMgt.Reset;
    end;


    procedure TestStatus()
    begin
        if Status = Status::Certified then
            FieldError(Status);
    end;


    procedure ValidateLayout()
    var
        PhantomDocumentLayout: Record "DC - Document Layout";
        DocumentLayoutCodeunit: Record "DC - Document Layout Codeunit";
        DocumentLayoutCriteria: Record "DC - Document Layout Criterion";
        DocumentLayoutField: Record "DC - Document Layout Field";
        DocumentLayoutFilter: Record "DC - Document Layout Filter";
        DocumentLayoutLine: Record "DC - Document Layout Line";
        DocumentLayoutVariable: Record "DC - Document Layout Variable";
        Window: Dialog;
    begin
        Window.Open(Text002);

        if not "Phantom Layout" then
            TestField("Report No.")
        else
            TestField("Report No.", 0);

        if "Phantom Layout" then
            TestField("Document Label Code", '');

        TestField("Top DataItem Table No.");

        DocumentLayoutLine.SetRange("Layout No.", "No.");
        DocumentLayoutLine.FindSet(true, false);
        repeat
            DocumentLayoutLine.TestField("Table No.");
            DocumentLayoutLine.TestField("Key No.");
            DocumentLayoutLine.Validate(Level);
            DocumentLayoutLine.Modify;
            if DocumentLayoutLine."Phantom Layout No." <> '' then begin
                PhantomDocumentLayout.Get(DocumentLayoutLine."Phantom Layout No.");
                PhantomDocumentLayout.TestField("Top DataItem Table No.", DocumentLayoutLine."Table No.");
                PhantomDocumentLayout.TestField("Phantom Layout");
                PhantomDocumentLayout.TestField(Status, PhantomDocumentLayout.Status::Certified);
            end;
            if "Phantom Layout" then
                PhantomDocumentLayout.TestField("Phantom Layout", false);
        until DocumentLayoutLine.Next = 0;

        DocumentLayoutField.SetRange("Layout No.", "No.");
        if DocumentLayoutField.FindSet(false, false) then
            repeat
                if DocumentLayoutField.Type = DocumentLayoutField.Type::Value then begin
                    DocumentLayoutField.TestField("Table No.");
                    DocumentLayoutField.TestField("Field No.");
                    FieldExists(DocumentLayoutField."Table No.", DocumentLayoutField."Field No.");
                end;
                if DocumentLayoutField.Type = DocumentLayoutField.Type::Caption then begin
                    DocumentLayoutField.TestField("Table No.");
                    DocumentLayoutField.TestField("Field No.");
                    FieldExists(DocumentLayoutField."Table No.", DocumentLayoutField."Field No.");
                end;
                if DocumentLayoutField.Type = DocumentLayoutField.Type::"Document Text" then
                    DocumentLayoutField.TestField("Document Text Code");
                if DocumentLayoutField.Type = DocumentLayoutField.Type::System then
                    if DocumentLayoutField."System Value" = DocumentLayoutField."System Value"::" " then
                        DocumentLayoutField.FieldError("System Value");
                if DocumentLayoutField."Allow Line Break" then
                    DocumentLayoutField.TestField("Field Width (pt)");
                if DocumentLayoutField."Carry Over" <> DocumentLayoutField."Carry Over"::" " then
                    DocumentLayoutField.TestCarryOver;
            until DocumentLayoutField.Next = 0;

        DocumentLayoutFilter.SetRange("Layout No.", "No.");
        if DocumentLayoutFilter.FindSet(false, false) then
            repeat
                DocumentLayoutFilter.InitTableNo;
                DocumentLayoutFilter.Modify;
                DocumentLayoutFilter.TestField("Field No.");
                FieldExists(DocumentLayoutFilter."Table No.", DocumentLayoutFilter."Field No.");
                if DocumentLayoutFilter."Filter Type" = DocumentLayoutFilter."Filter Type"::Value then begin
                    DocumentLayoutFilter.TestField("Filter Field No.");
                    FieldExists(DocumentLayoutFilter."Filter Table No.", DocumentLayoutFilter."Filter Field No.");
                end;
                if DocumentLayoutFilter."Filter Type" = DocumentLayoutFilter."Filter Type"::System then
                    if DocumentLayoutFilter."System Value" = DocumentLayoutFilter."System Value"::" " then
                        DocumentLayoutFilter.FieldError("System Value");
            until DocumentLayoutFilter.Next = 0;

        DocumentLayoutCriteria.SetRange("Layout No.", "No.");
        if DocumentLayoutCriteria.FindSet(false, false) then
            repeat
                DocumentLayoutCriteria.TestField("Table No.");
            until DocumentLayoutCriteria.Next = 0;

        DocumentLayoutVariable.SetRange("Layout No.", "No.");
        if DocumentLayoutVariable.FindSet(false, false) then
            repeat
                if DocumentLayoutVariable.Type = DocumentLayoutVariable.Type::Value then begin
                    DocumentLayoutVariable.TestField("Table No.");
                    DocumentLayoutVariable.TestField("Field No.");
                    FieldExists(DocumentLayoutVariable."Table No.", DocumentLayoutVariable."Field No.");
                end;
                if DocumentLayoutVariable.Type = DocumentLayoutVariable.Type::Caption then begin
                    DocumentLayoutVariable.TestField("Table No.");
                    DocumentLayoutVariable.TestField("Field No.");
                    FieldExists(DocumentLayoutVariable."Table No.", DocumentLayoutVariable."Field No.");
                end;
                if DocumentLayoutVariable.Type = DocumentLayoutVariable.Type::Formula then
                    DocumentLayoutVariable.TestField(Formula);
                if DocumentLayoutVariable.Type = DocumentLayoutVariable.Type::System then
                    if DocumentLayoutVariable."System Value" = DocumentLayoutVariable."System Value"::" " then
                        DocumentLayoutVariable.FieldError("System Value");
                if DocumentLayoutVariable.Type = DocumentLayoutVariable.Type::"Record ID" then
                    DocumentLayoutVariable.TestField("Table No.");
            until DocumentLayoutVariable.Next = 0;

        Window.Close;
    end;


    procedure FieldExists(TableNo: Integer; FieldNo: Integer)
    var
        "Field": Record "Field";
    begin
        Field.Get(TableNo, FieldNo);
    end;


    procedure LaunchQuickView(Type: Integer)
    var
        DocumentConfigMng: Codeunit "DC - Management";
    begin
        if Status <> Status::Certified then begin
            ValidateLayout;
            Commit;
        end;

        DocumentConfigMng.LaunchQuickView("No.", Type);
    end;
}


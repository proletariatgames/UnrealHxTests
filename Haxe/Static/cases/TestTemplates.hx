package cases;
import NonUObject;
import SomeEnum;
import templates.TemplatesDef;
import unreal.*;

using buddy.Should;

class TestTemplates extends buddy.BuddySuite {
  public function new() {
    describe('Haxe - Templates', {
      it('should be able to call templated functions', {
        // UTemplatesDef.getSomeStaticInt(new TypeParam<UTemplatesDef>()).should.be(42);
      });
    });
  }
}

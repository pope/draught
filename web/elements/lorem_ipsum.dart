import 'package:polymer/polymer.dart';
import 'dart:math';

@CustomTag('lorem-ipsum')
class LoremIpsumElement extends PolymerElement {

  static final List<String> strings =
      ['Lorem ipsum dolor sit amet, per in nusquam nominavi periculis, sit elit oportere ea, id minim maiestatis incorrupte duo. Dolorum verterem ad ius, his et nullam verterem. Eu alia debet usu, an doming tritani est. Vix ad ponderum petentium suavitate, eum eu tempor populo, graece sententiae constituam vim ex. Cu torquatos reprimique neglegentur nec, voluptua periculis has ut, at eos discere deleniti sensibus.',
      'Ut labores minimum atomorum pro. Laudem tibique ut has. No nam ipsum lorem aliquip, accumsan quaerendum ei usu. Maiestatis vituperatoribus qui at, ne suscipit volutpat tractatos nam. Nonumy semper mollis vis an, nam et harum detracto. An pri dolor percipitur, vel maluisset disputationi te.',
      'Fugit adolescens vis et, ei graeci forensibus sed. Denique argumentum comprehensam ei vis, id has facete accommodare, quo scripta utroque id. Autem nullam doming ad eam, te nam dicam iriure periculis. Quem vocent veritus eu vis, nam ut hinc idque feugait.',
      'Convenire definiebas scriptorem eu cum. Sit dolor dicunt consectetuer no, in vix nisl velit, duo ridens abhorreant delicatissimi ut. Pro ei libris omnium scripserit, natum volumus propriae no eam. Suscipit pericula explicari sed ei, te usu iudicabit forensibus efficiantur. Has quot dicam animal id.',
      'Ea duis bonorum nec, falli paulo aliquid ei eum. Cu mei vide viris gloriatur, at populo eripuit sit. Idque molestiae duo ne. Qui id tempor accusamus sadipscing. His odio feugait et. Ne vis vide labitur, eu corpora appareat interpretaris mel.',
      'Usu eu novum principes, vel quodsi aliquip ea. Labore mandamus persequeris id mea, has eripuit neglegentur id, illum noster nec in. Ea nam quod quando cetero, per qualisque tincidunt in. Qui ne meliore commune voluptatibus, qui justo labores no. Et dicat cotidieque eos, vis homero legere et, eam timeam nominavi in. Pri dicam option placerat an, cu qui aliquam adipiscing signiferumque. Vis euismod accusamus no, soluta vocibus ei cum.',
      'Has at minim mucius aliquam, est id tempor laoreet. Ius officiis convenire ex, in vim iuvaret patrioque similique, veritus detraxit sed ad. Mel no admodum abhorreant cotidieque, et duo possim postulant, consul convenire adolescens cu mel. Duo in decore soleat doming. Fabellas interpretaris eos at. No cum unum novum dicit.',
      'Pro saepe pertinax ei, ad pri animal labores suscipiantur. Modus commodo minimum eum te, vero utinam assueverit per eu, zril oportere suscipiantur pri te. Partem percipitur deterruisset ad sea, at eam suas luptatum dissentiunt. No error alienum pro, erant senserit ex mei, pri semper alterum no. Ut habemus menandri vulputate mea. Feugiat verterem ut sed. Dolores maiestatis id per.',
      'Detracto suavitate repudiandae no eum. Id adhuc minim soluta nam, novum denique ad eum. At mucius malorum meliore his, te ferri tritani cum, eu mel legendos ocurreret. His te ludus aperiam malorum, mundi nominati deseruisse pro ne, mel discere intellegat in. Vero dissentiunt quo in, vel cu meis maiestatis adversarium. In sit summo nostrum petentium, ea vix amet nullam minimum, ornatus sensibus theophrastus ex nam.',
      'Iisque perfecto dissentiet cum et, sit ut quot mandamus, ut vim tibique splendide instructior. Id nam odio natum malorum, tibique copiosae expetenda mel ea. Mea melius malorum ut. Ut nec tollit vocent timeam. Facer nonumy numquam id his, munere salutatus consequuntur eum et, eum cotidieque definitionem signiferumque id. Ei oblique graecis patrioque vis, et probatus dignissim inciderint vel. Sed id paulo erroribus, autem semper accusamus in mel.'];

  @published int paragraphs = 1;
  @observable final List<String> paragraphList = toObservable([]);
  final Random _rand = new Random();

  LoremIpsumElement.created() : super.created();

  void paragraphsChanged(oldValue) {
    if (paragraphs < paragraphList.length) {
      paragraphList.removeRange(paragraphs, paragraphList.length);
      return;
    }
    for (var i = paragraphList.length; i < paragraphs; i++) {
      paragraphList.add(strings[_rand.nextInt(strings.length)]);
    }
  }
}
